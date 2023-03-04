from django.conf import settings
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.conf import settings


def send_account_verification_code(code, email, lang):
    subject = render_to_string(
        "authentication/notifications/{}/account_verification_code_subject.txt".format(lang)
    )
    body = render_to_string(
        "authentication/notifications/{}/account_verification_code_body.txt".format(lang),
        {"code": code},
    )
    send_mail(
        subject,
        body,
        settings.EMAIL_HOST_USER,
        [email],
        fail_silently=False
    )

def send_password_reset_code(code, email, lang):
    subject = render_to_string(
        "authentication/notifications/{}/password_code_subject.txt".format(lang)
    )
    body = render_to_string(
        "authentication/notifications/{}/password_code_body.txt".format(lang),
        {"code": code},
    )
    send_mail(
        subject,
        body,
        settings.EMAIL_HOST_USER,
        [email],
        fail_silently=False
    )