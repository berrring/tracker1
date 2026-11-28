"""Test a local Supabase Auth server with a local Mailpit inbox."""
import base64
import hashlib
import html
import json
import re
import secrets
import time
from urllib.error import HTTPError
from urllib.parse import parse_qs, urlencode, urlsplit
from urllib.request import HTTPRedirectHandler, Request, build_opener, urlopen

AUTH = "http://127.0.0.1:8488"
MAIL = "http://127.0.0.1:8489"
CALLBACK = "http://127.0.0.1:8490/?account=1"
EMAIL = f"fixture-{secrets.token_hex(6)}@example.test"


def request(base, path, data=None, token=None):
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    body = None if data is None else json.dumps(data).encode()
    with urlopen(Request(base + path, data=body, headers=headers), timeout=8) as response:
        return json.load(response)


def verifier():
    value = secrets.token_urlsafe(40)
    digest = hashlib.sha256(value.encode()).digest()
    return value, {
        "code_challenge_method": "s256",
        "code_challenge": base64.urlsafe_b64encode(digest).decode().rstrip("="),
    }


def email_url(subject_pattern):
    for _ in range(30):
        envelope = request(MAIL, "/api/v1/messages")
        for item in envelope["messages"]:
            if not re.search(subject_pattern, item["Subject"], re.I):
                continue
            if not any(addr["Address"] == EMAIL for addr in item["To"]):
                continue
            message = request(MAIL, f'/api/v1/message/{item["ID"]}')
            for field in ("Text", "HTML"):
                result = re.search(r'https?://[^\s<>"\']+/verify\?[^\s<>"\']+', html.unescape(message.get(field) or ""))
                if result:
                    return result.group()
        time.sleep(.25)
    raise AssertionError(f"Missing local message: {subject_pattern}")


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def redeem(link, value):
    try:
        build_opener(NoRedirect()).open(link, timeout=8)
    except HTTPError as result:
        assert result.code in (302, 303), result.code
        destination = urlsplit(result.headers["Location"])
        assert destination.netloc == "127.0.0.1:8490", destination.netloc
        query = parse_qs(destination.query)
        assert query.get("account") == ["1"]
        return request(AUTH, "/token?grant_type=pkce", {
            "auth_code": query["code"][0],
            "code_verifier": value,
        })
    raise AssertionError("Email verification did not redirect")


def login(password):
    return request(AUTH, "/token?grant_type=password", {"email": EMAIL, "password": password})


def reject_login(password):
    try:
        login(password)
    except HTTPError as error:
        assert error.code == 400
    else:
        raise AssertionError("Unexpected login success")


def main():
    suffix = "?" + urlencode({"redirect_to": CALLBACK})
    password = secrets.token_urlsafe(18)
    value, params = verifier()
    pending = request(AUTH, "/signup" + suffix, {"email": EMAIL, "password": password, **params})
    assert not pending.get("access_token")
    reject_login(password)
    signup = redeem(email_url("confirm"), value)
    assert signup["user"]["email"] == EMAIL
    session = login(password)
    restored = request(AUTH, "/token?grant_type=refresh_token", {"refresh_token": session["refresh_token"]})
    assert restored["user"]["id"] == signup["user"]["id"]
    value, params = verifier()
    request(AUTH, "/recover" + suffix, {"email": EMAIL, **params})
    recovered = redeem(email_url(r"reset|password"), value)
    replacement = secrets.token_urlsafe(18)
    updated = Request(
        AUTH + "/user", method="PUT",
        data=json.dumps({"password": replacement}).encode(),
        headers={"Content-Type": "application/json",
                 "Authorization": f'Bearer {recovered["access_token"]}'},
    )
    with urlopen(updated, timeout=8) as response:
        assert json.load(response)["id"] == signup["user"]["id"]
    reject_login(password)
    assert login(replacement)["user"]["email"] == EMAIL
    print("Local Auth smoke test passed: confirmation, login, refresh, recovery and password change.")


if __name__ == "__main__":
    main()
