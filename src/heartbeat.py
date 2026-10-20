import datetime


def handler(event, context):
    """Synthetic heartbeat checked by alarms and shown on the dashboard."""
    now = datetime.datetime.utcnow().isoformat()
    print(f"heartbeat ok at {now}")
    return {"status": "ok", "timestamp": now}
