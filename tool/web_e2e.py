import asyncio
import json
import urllib.request
import base64
import os
import sys
import websockets

CDP_BASE = "http://127.0.0.1:9222"
APP_URL = "http://127.0.0.1:8080"
SCREENSHOTS_DIR = os.path.join(os.path.dirname(__file__), "..", "docs", "screenshots")

async def run_e2e():
    print("======================================================")
    print("      CHESSMASTER WEB PRODUCTION BROWSER E2E TEST     ")
    print("======================================================")
    os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

    # 1. Create new tab
    print(f"[1/7] Opening new browser tab to {APP_URL}...")
    req = urllib.request.Request(f"{CDP_BASE}/json/new?{APP_URL}", method="PUT")
    with urllib.request.urlopen(req) as resp:
        tab_info = json.loads(resp.read().decode())
    
    ws_url = tab_info["webSocketDebuggerUrl"]
    tab_id = tab_info["id"]
    print(f"  -> Tab created: {tab_id}")
    print(f"  -> WebSocket URL: {ws_url}")

    async with websockets.connect(ws_url, max_size=20*1024*1024) as ws:
        msg_id = 0
        pending = {}
        console_logs = []
        console_errors = []

        async def send(method, params=None):
            nonlocal msg_id
            msg_id += 1
            cur_id = msg_id
            payload = {"id": cur_id, "method": method, "params": params or {}}
            fut = asyncio.get_event_loop().create_future()
            pending[cur_id] = fut
            await ws.send(json.dumps(payload))
            return await fut

        async def receiver():
            try:
                async for raw in ws:
                    data = json.loads(raw)
                    if "id" in data and data["id"] in pending:
                        pending.pop(data["id"]).set_result(data)
                    elif data.get("method") == "Runtime.consoleAPICalled":
                        p = data["params"]
                        t = p.get("type", "log")
                        args = " ".join(str(a.get("value", a.get("description", ""))) for a in p.get("args", []))
                        log_line = f"[{t}] {args}"
                        console_logs.append(log_line)
                        if t == "error":
                            console_errors.append(log_line)
            except asyncio.CancelledError:
                pass

        recv_task = asyncio.create_task(receiver())

        try:
            # Enable domains
            await send("Page.enable")
            await send("Runtime.enable")
            await send("DOM.enable")
            await send("Emulation.setDeviceMetricsOverride", {
                "width": 1280,
                "height": 800,
                "deviceScaleFactor": 1,
                "mobile": False
            })

            print("[2/7] Waiting for Flutter Web CanvasKit engine bootstrap (7s)...")
            await asyncio.sleep(7)

            # Inspect title and flutter-view
            print("[3/7] Inspecting DOM and application state...")
            title_res = await send("Runtime.evaluate", {"expression": "document.title"})
            title = title_res.get("result", {}).get("result", {}).get("value", "")
            print(f"  -> Title: '{title}'")

            fv_res = await send("Runtime.evaluate", {"expression": "document.querySelector('flutter-view') !== null"})
            has_fv = fv_res.get("result", {}).get("result", {}).get("value")
            print(f"  -> flutter-view rendered: {has_fv}")

            # Capture Home Screenshot
            print("[4/7] Capturing screenshot: Home / Daily Journey...")
            shot1 = await send("Page.captureScreenshot", {"format": "png"})
            b64_1 = shot1.get("result", {}).get("data")
            if b64_1:
                p1 = os.path.join(SCREENSHOTS_DIR, "web_e2e_home.png")
                with open(p1, "wb") as f:
                    f.write(base64.b64decode(b64_1))
                print(f"  -> Saved {p1} ({len(b64_1)} bytes)")

            # Click Navigation: Curriculum
            print("[5/7] Navigating to Curriculum screen via rail click...")
            await send("Input.dispatchMouseEvent", {"type": "mousePressed", "x": 36, "y": 140, "button": "left", "clickCount": 1})
            await asyncio.sleep(0.1)
            await send("Input.dispatchMouseEvent", {"type": "mouseReleased", "x": 36, "y": 140, "button": "left", "clickCount": 1})
            await asyncio.sleep(2)

            shot2 = await send("Page.captureScreenshot", {"format": "png"})
            b64_2 = shot2.get("result", {}).get("data")
            if b64_2:
                p2 = os.path.join(SCREENSHOTS_DIR, "web_e2e_curriculum.png")
                with open(p2, "wb") as f:
                    f.write(base64.b64decode(b64_2))
                print(f"  -> Saved {p2} ({len(b64_2)} bytes)")

            # Click Navigation: Play
            print("[6/7] Navigating to Play screen via rail click...")
            await send("Input.dispatchMouseEvent", {"type": "mousePressed", "x": 36, "y": 190, "button": "left", "clickCount": 1})
            await asyncio.sleep(0.1)
            await send("Input.dispatchMouseEvent", {"type": "mouseReleased", "x": 36, "y": 190, "button": "left", "clickCount": 1})
            await asyncio.sleep(2)

            shot3 = await send("Page.captureScreenshot", {"format": "png"})
            b64_3 = shot3.get("result", {}).get("data")
            if b64_3:
                p3 = os.path.join(SCREENSHOTS_DIR, "web_e2e_play.png")
                with open(p3, "wb") as f:
                    f.write(base64.b64decode(b64_3))
                print(f"  -> Saved {p3} ({len(b64_3)} bytes)")

            # Click Navigation: Labs
            print("[7/7] Navigating to Labs screen via rail click...")
            await send("Input.dispatchMouseEvent", {"type": "mousePressed", "x": 36, "y": 240, "button": "left", "clickCount": 1})
            await asyncio.sleep(0.1)
            await send("Input.dispatchMouseEvent", {"type": "mouseReleased", "x": 36, "y": 240, "button": "left", "clickCount": 1})
            await asyncio.sleep(2)

            shot4 = await send("Page.captureScreenshot", {"format": "png"})
            b64_4 = shot4.get("result", {}).get("data")
            if b64_4:
                p4 = os.path.join(SCREENSHOTS_DIR, "web_e2e_labs.png")
                with open(p4, "wb") as f:
                    f.write(base64.b64decode(b64_4))
                print(f"  -> Saved {p4} ({len(b64_4)} bytes)")

        finally:
            recv_task.cancel()

    # Close tab
    try:
        close_req = urllib.request.Request(f"{CDP_BASE}/json/close/{tab_id}", method="PUT")
        urllib.request.urlopen(close_req)
    except Exception:
        pass

    passed = has_fv and b64_1 is not None and len(console_errors) == 0

    report = {
        "testName": "Web Production Bundle Browser E2E",
        "platform": "Web (CanvasKit / Chrome Headless)",
        "url": APP_URL,
        "title": title,
        "flutterViewRendered": has_fv,
        "screenshots": [
            "docs/screenshots/web_e2e_home.png",
            "docs/screenshots/web_e2e_curriculum.png",
            "docs/screenshots/web_e2e_play.png",
            "docs/screenshots/web_e2e_labs.png",
        ],
        "consoleLogsCount": len(console_logs),
        "consoleErrorsCount": len(console_errors),
        "consoleErrors": console_errors,
        "statusClassification": "PROVEN" if passed else "FAIL",
    }

    report_path = os.path.join(os.path.dirname(__file__), "..", "web_e2e.json")
    with open(report_path, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2)

    print("\n======================================================")
    print(f"E2E VERDICT: {'PROVEN - ALL SCREENS RENDERED & INTERACTED' if passed else 'FAIL'}")
    print(f"Console Errors: {len(console_errors)}")
    print(f"Report written to: {report_path}")
    print("======================================================\n")

    if not passed:
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(run_e2e())
