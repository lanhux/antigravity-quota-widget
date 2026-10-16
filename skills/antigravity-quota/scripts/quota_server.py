#!/usr/bin/env python3
"""
Antigravity Local Quota Bridge Server (http://127.0.0.1:12655/api/quota)
Automatically discovers the local Antigravity language_server process,
queries RetrieveUserQuotaSummary & GetUserStatus, and serves CORS-enabled JSON
for the Antigravity Quota Dashboard widget.
"""

import json
import os
import re
import subprocess
import sys
import time
import urllib.request
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 12655
_cached_conn = {"port": None, "csrf": None, "pid": None, "ts": 0}


def discover_language_server():
    now = time.time()
    if _cached_conn["port"] and (now - _cached_conn["ts"] < 30):
        return _cached_conn["port"], _cached_conn["csrf"]

    try:
        if sys.platform == "win32":
            ps_cmd = (
                "$p = Get-CimInstance Win32_Process | Where-Object { $_.Name -match 'language_server' } | Select-Object -First 1; "
                "if ($p) { "
                "$ports = Get-NetTCPConnection -OwningProcess $p.ProcessId -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty LocalPort; "
                "@{ pid = $p.ProcessId; cmd = $p.CommandLine; ports = @($ports) } | ConvertTo-Json -Compress "
                "}"
            )
            out = subprocess.check_output(
                ["powershell", "-NoProfile", "-Command", ps_cmd],
                timeout=5,
                creationflags=0x08000000 if sys.platform == "win32" else 0,
            ).decode("utf-8", errors="ignore").strip()
            if not out:
                return None, None
            info = json.loads(out)
            cmd = info.get("cmd") or ""
            m = re.search(r"--csrf_token[=\s]+([^\s\"]+)", cmd)
            csrf = m.group(1) if m else ""
            ports = info.get("ports") or []
            if isinstance(ports, int):
                ports = [ports]
        else:
            ps_out = subprocess.check_output(["ps", "-ef"], timeout=3).decode("utf-8", errors="ignore")
            csrf = ""
            ports = []
            for line in ps_out.splitlines():
                if "language_server" in line and "--csrf_token" in line:
                    m = re.search(r"--csrf_token[=\s]+([^\s\"]+)", line)
                    if m:
                        csrf = m.group(1)
                    break

        for p in ports:
            try:
                req = urllib.request.Request(
                    f"http://127.0.0.1:{p}/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary",
                    data=b"{}",
                    headers={
                        "x-codeium-csrf-token": csrf,
                        "Connect-Protocol-Version": "1",
                        "Content-Type": "application/json",
                    },
                    method="POST",
                )
                with urllib.request.urlopen(req, timeout=1.5) as resp:
                    if resp.status == 200:
                        _cached_conn.update({"port": p, "csrf": csrf, "ts": now})
                        return p, csrf
            except Exception:
                continue
    except Exception:
        pass
    return None, None


def call_rpc(port, csrf, method, payload=b"{}"):
    req = urllib.request.Request(
        f"http://127.0.0.1:{port}/exa.language_server_pb.LanguageServerService/{method}",
        data=payload,
        headers={
            "x-codeium-csrf-token": csrf,
            "Connect-Protocol-Version": "1",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=3) as resp:
        return json.loads(resp.read().decode("utf-8", errors="ignore"))


def fetch_live_quota():
    port, csrf = discover_language_server()
    if not port:
        _cached_conn["port"] = None
        port, csrf = discover_language_server()
    if not port:
        return {"status": "error", "message": "language_server not found"}

    try:
        q_res = call_rpc(port, csrf, "RetrieveUserQuotaSummary")
    except Exception:
        _cached_conn["port"] = None
        port, csrf = discover_language_server()
        if not port:
            return {"status": "error", "message": "language_server unreachable"}
        q_res = call_rpc(port, csrf, "RetrieveUserQuotaSummary")

    groups = q_res.get("response", {}).get("groups", [])
    user_info = {
        "name": "刘枭",
        "email": "liushuiyiran@gmail.com",
        "tier": "Google AI Pro",
        "plan": "Pro",
    }
    try:
        u_res = call_rpc(port, csrf, "GetUserStatus")
        us = u_res.get("userStatus", {})
        if us.get("name"):
            user_info["name"] = us["name"]
        if us.get("email"):
            user_info["email"] = us["email"]
        tier_name = us.get("userTier", {}).get("name")
        if tier_name:
            user_info["tier"] = tier_name
        plan_name = us.get("planStatus", {}).get("planInfo", {}).get("planName")
        if plan_name:
            user_info["plan"] = plan_name
    except Exception:
        pass

    return {
        "status": "ok",
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "user": user_info,
        "quota": {
            "groups": groups,
            "description": q_res.get("response", {}).get("description", ""),
        },
    }


class QuotaHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def _send_cors(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")

    def do_OPTIONS(self):
        self.send_response(204)
        self._send_cors()
        self.end_headers()

    def do_GET(self):
        if self.path.startswith("/api/quota"):
            data = fetch_live_quota()
            body = json.dumps(data, ensure_ascii=False).encode("utf-8")
            self.send_response(200)
            self._send_cors()
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        else:
            self.send_response(404)
            self._send_cors()
            self.end_headers()


if __name__ == "__main__":
    server = HTTPServer(("127.0.0.1", PORT), QuotaHandler)
    print(f"Antigravity Quota Bridge listening on http://127.0.0.1:{PORT}/api/quota", flush=True)
    server.serve_forever()
