from celery import shared_task
from authentication import notifications

@shared_task
def send_account_verification_code(code, email, lang):
    notifications.send_account_verification_code(code, email, lang)

@shared_task
def send_password_reset_code(code, email, lang):   
    notifications.send_password_reset_code(code, email, lang)