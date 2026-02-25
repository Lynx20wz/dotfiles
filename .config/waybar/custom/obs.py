#!/home/lynx20wz/documents/programming/python/!others/.venv/bin/python

import json

import obsws_python as obs


def main():
    try:
        client = obs.ReqClient(host="localhost", port=4455)
    except Exception:
        print(json.dumps({"text": ""}))
        return

    scene = client.get_current_program_scene()
    print(json.dumps({"text": scene.current_program_scene_name}))


if __name__ == "__main__":
    main()
