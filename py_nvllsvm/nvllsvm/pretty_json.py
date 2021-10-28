import json


def pretty_json(data):
    """
    Return a pretty JSON string

    The resulting string is valid JSON - both indented and sorted.

    :param data: Python data object
    """
    return json.dumps(
        data,
        indent=2,
        sort_keys=True,
        default=_default_json,
        ensure_ascii=False
    )


def _default_json(obj):
    if isinstance(obj, set):
        return sorted(obj)
    elif hasattr(obj, 'isoformat'):
        return obj.isoformat()
