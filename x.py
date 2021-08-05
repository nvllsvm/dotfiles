import datetime


def stuff(days):
    now = datetime.datetime.utcnow()
    temp_records = {
        {'date': (now - datetime.timedelta(offset)).strftime('%Y-%m-%d'),
         'total_size': 0,
         'uploaded_images': 0}
        for offset in range(days)
    }
    return temp_records


print(stuff(3))
