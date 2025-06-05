#!/usr/bin/env python3
import argparse
import smtplib
import email.message


class MTA:
    def __init__(self, host, port, username, password, starttls):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.starttls = starttls

    def send_message(
        self, to_address, from_address, subject, body_html=None, body_text=None
    ):
        message = email.message.EmailMessage()
        message["subject"] = subject
        message["from"] = from_address
        message["to"] = to_address

        if body_text:
            message.set_content(body_text, subtype="text")
            if body_html:
                message.add_alternative(body_html, subtype="html")
        elif body_html:
            message.set_content(body_html, subtype="html")
        else:
            raise ValueError("must specify either body_html and/or body_text")

        with smtplib.SMTP(self.host, self.port) as smtp:
            if self.starttls:
                smtp.starttls()
            smtp.login(self.username, self.password)
            smtp.send_message(message)
            smtp.quit()


def main():
    parser = argparse.ArgumentParser()

    mta_group = parser.add_argument_group("mta")
    mta_group.add_argument("--host", required=True)
    mta_group.add_argument("--port", type=int, required=True)
    mta_group.add_argument("--username", required=True)
    mta_group.add_argument("--password", required=True)
    mta_group.add_argument("--starttls", action="store_true")

    message_group = parser.add_argument_group("message")
    message_group.add_argument("--from", dest="from_address", required=True)
    message_group.add_argument("--to", dest="to_address", required=True)
    message_group.add_argument("--subject", required=True)
    message_group.add_argument("--html", dest="body_html")
    message_group.add_argument("--text", dest="body_text")

    args = parser.parse_args()

    if not any([args.body_html, args.body_text]):
        parser.error("must specifiy --html and/or --text")
        parser.exit(1)

    mta = MTA(
        username=args.username,
        password=args.password,
        host=args.host,
        port=args.port,
        starttls=args.starttls,
    )

    mta.send_message(
        to_address=args.to_address,
        from_address=args.from_address,
        subject=args.subject,
        body_html=args.body_html,
        body_text=args.body_text,
    )


if __name__ == "__main__":
    main()
