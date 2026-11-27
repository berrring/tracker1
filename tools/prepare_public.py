"""Copy a built Flutter Web release into the Git-tracked Vercel output."""
from pathlib import Path
import shutil


def main():
    root = Path(__file__).resolve().parent.parent
    source = root / "build" / "web"
    target = root / "public"
    required = ("index.html", "main.dart.js", "flutter_bootstrap.js", "tracker_serial.js")
    for file in required:
        if not (source / file).is_file():
            raise SystemExit(f"Build the Flutter release first. Missing {file}")
    if source.resolve() != source or target.resolve() != target:
        raise SystemExit("Build and output directories must be under the workspace.")
    if any(path.is_symlink() for path in source.rglob("*")):
        raise SystemExit("Unexpected symlink in Flutter output.")
    if target.exists():
        if not all((target / file).is_file() for file in required):
            raise SystemExit("Existing public/ does not look like a SafeTrack release.")
        shutil.rmtree(target)
    shutil.copytree(
        source, target, ignore=shutil.ignore_patterns("*.map", "*.symbols", ".last_build_id")
    )
    print(f"Prepared {sum(path.is_file() for path in target.rglob('*'))} files in public/.")


if __name__ == "__main__":
    main()
