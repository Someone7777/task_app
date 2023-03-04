from pathlib import Path
from configurations import Configuration
from django.utils.timezone import timedelta
import os
from django.utils.translation import gettext_lazy as _
import environ
from Crypto.PublicKey import RSA
from django.core.management.utils import get_random_secret_key

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent
env = environ.Env(
    APP_DEBUG=(bool, os.getenv("APP_DEBUG", default=True)),
    APP_ALLOWED_HOSTS=(str, os.getenv("APP_ALLOWED_HOSTS", default='*')),
    APP_CORS_HOSTS=(str, os.getenv("APP_CORS_HOSTS")),
    DATABASE_URL=(str, os.getenv("DATABASE_URL",
                                 default='sqlite:///'+os.path.join(BASE_DIR, 'default.sqlite3'))),
    APP_EMAIL_CODE_THRESHOLD=(int, os.getenv(
        "APP_EMAIL_CODE_THRESHOLD", default=120)),
    APP_EMAIL_CODE_VALID=(int, os.getenv("APP_EMAIL_CODE_VALID", default=120)),
    APP_EMAIL_HOST=(str, os.getenv(
        "APP_EMAIL_HOST", default='smtp.gmail.com')),
    APP_EMAIL_PORT=(int, os.getenv("APP_EMAIL_PORT", default=587)),
    APP_EMAIL_HOST_USER=(str, os.getenv(
        "APP_EMAIL_HOST_USER", default='example@gmail.com')),
    APP_EMAIL_HOST_PASSWORD=(str, os.getenv(
        "APP_EMAIL_HOST_PASSWORD", default='password')),
    APP_CELERY_BROKER_URL=(str, os.getenv(
        "APP_CELERY_BROKER_URL", default="redis://localhost:6379/0")),
)


class Dev(Configuration):
    # Build paths inside the project like this: BASE_DIR / 'subdir'.
    BASE_DIR = Path(__file__).resolve().parent.parent

    private_key_file = os.path.join(BASE_DIR, 'private.key')
    public_key_file = os.path.join(BASE_DIR, 'public.key')

    if os.path.exists(private_key_file):
        print("* Using SECRET key from file")
        with open(private_key_file, 'rb') as reader:
            RSAkey = RSA.importKey(reader.read())
    else:
        print("* Generating SECRET key")
        RSAkey = RSA.generate(4096)
        with open(private_key_file, 'wb') as writer:
            print("* Generating PRIVATE key file")
            writer.write(RSAkey.exportKey())
        if not os.path.exists(public_key_file):
            with open(public_key_file, 'wb') as writer:
                print("* Generating PUBLIC key file")
                writer.write(RSAkey.publickey().exportKey())
    SECRET_KEY = get_random_secret_key()

    DEBUG = env('APP_DEBUG')

    ALLOWED_HOSTS = env('APP_ALLOWED_HOSTS').split(',')

    if env('APP_CORS_HOSTS'):
        CORS_ALLOW_ALL_ORIGINS = False
        CORS_ALLOWED_ORIGINS = env('APP_CORS_HOSTS').split(',')
    else:
        CORS_ALLOW_ALL_ORIGINS = True

    X_FRAME_OPTIONS = 'DENY'

    INSTALLED_APPS = [
        'django.contrib.admin',
        'django.contrib.auth',
        'django.contrib.contenttypes',
        'django.contrib.sessions',
        'django.contrib.messages',
        'django.contrib.staticfiles',
        # Task schedulling:
        'django_celery_results',
        'django_celery_beat',
        # Cors:
        "corsheaders",
        # Admin documentation:
        'django.contrib.admindocs',
        # Rest framework:
        'rest_framework',
        'django_filters',
        # Swager:
        'drf_yasg',
        # Custom apps:
        'authentication',
        'tasks',
        'core',
    ]

    MIDDLEWARE = [
        "corsheaders.middleware.CorsMiddleware",
        'django.middleware.security.SecurityMiddleware',
        'django.contrib.sessions.middleware.SessionMiddleware',
        'django.middleware.locale.LocaleMiddleware',
        'django.middleware.common.CommonMiddleware',
        'django.middleware.csrf.CsrfViewMiddleware',
        'django.contrib.auth.middleware.AuthenticationMiddleware',
        'django.contrib.messages.middleware.MessageMiddleware',
        'django.middleware.clickjacking.XFrameOptionsMiddleware',
    ]

    ROOT_URLCONF = 'core.urls'

    TEMPLATES = [
        {
            'BACKEND': 'django.template.backends.django.DjangoTemplates',
            'DIRS': [],
            'APP_DIRS': True,
            'OPTIONS': {
                'context_processors': [
                    'django.template.context_processors.debug',
                    'django.template.context_processors.request',
                    'django.contrib.auth.context_processors.auth',
                    'django.contrib.messages.context_processors.messages',
                ],
            },
        },
    ]

    WSGI_APPLICATION = 'core.wsgi.application'

    # Database
    # https://docs.djangoproject.com/en/4.1/ref/settings/#databases
    DATABASES = {"default": env.db()}

    # Password validation
    # https://docs.djangoproject.com/en/4.1/ref/settings/#auth-password-validators

    AUTH_PASSWORD_VALIDATORS = [
        {
            'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
        },
        {
            'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        },
        {
            'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
        },
        {
            'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
        },
    ]

    # Internationalization
    # https://docs.djangoproject.com/en/4.1/topics/i18n/

    LANGUAGE_CODE = 'en'
    LOCALE_PATHS = [
        BASE_DIR / 'locale/',
    ]
    LANGUAGES = (
        ('en', _('English')),
        ('es', _('Spanish')),
    )

    TIME_ZONE = "UTC"
    # Enables Django’s translation system
    USE_I18N = True
    # Django will display numbers and dates using the format of the current locale
    USE_L10N = True
    # Datetimes will be timezone-aware
    USE_TZ = True

    # Static files (CSS, JavaScript, Images)
    # https://docs.djangoproject.com/en/4.1/howto/static-files/

    STATIC_URL = 'static/'
    STATIC_ROOT = os.path.join(BASE_DIR, 'static')

    MEDIA_URL = 'media/'
    MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

    # Default primary key field type
    # https://docs.djangoproject.com/en/4.1/ref/settings/#default-auto-field

    DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

    LOGGING = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "verbose": {
                "format": "{levelname} {asctime} {module} {process:d} {thread:d} {message}",
                "style": "{",
            },
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "stream": "ext://sys.stdout",
                "formatter": "verbose",
            },
        },
        "root": {
            "handlers": ["console"],
            "level": "DEBUG",
        }
    }

    # Django Rest Framework setting:
    REST_FRAMEWORK = {
        "DEFAULT_AUTHENTICATION_CLASSES": [
            "rest_framework_simplejwt.authentication.JWTAuthentication"
        ],
        "DEFAULT_PERMISSION_CLASSES": [
            "rest_framework.permissions.IsAuthenticated",
        ],
        "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
        "PAGE_SIZE": 10,
        "DEFAULT_FILTER_BACKENDS": [
            "django_filters.rest_framework.DjangoFilterBackend",
        ],
        "DEFAULT_THROTTLE_CLASSES": [
            "rest_framework.throttling.AnonRateThrottle",
            "rest_framework.throttling.UserRateThrottle"
        ],
        "DEFAULT_THROTTLE_RATES": {
            "anon": "30/minute",
            "user": "100/minute",
            "jwt_obtain_pair": "50/minute",
            "jwt_refresh": "100/minute",
        },
    }

    SIMPLE_JWT = {
        'UPDATE_LAST_LOGIN': True,
        "ACCESS_TOKEN_LIFETIME": timedelta(days=1),
        "REFRESH_TOKEN_LIFETIME": timedelta(days=7),
        "ALGORITHM": 'RS256',
        "SIGNING_KEY": RSAkey.exportKey(),
        "VERIFYING_KEY": RSAkey.publickey().exportKey(),
    }

    SWAGGER_SETTINGS = {
        "SECURITY_DEFINITIONS": {
            "Token": {
                "type": "apiKey",
                "name": "Authorization",
                "in": "header"
            },
            "Basic": {
                "type": "basic"
            },
        }
    }

    AUTH_USER_MODEL = "authentication.User"

    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

    CELERY_RESULT_BACKEND = "django-db"
    CELERY_BROKER_URL = env("APP_CELERY_BROKER_URL")

    EMAIL_CODE_THRESHOLD = env('APP_EMAIL_CODE_THRESHOLD')
    EMAIL_CODE_VALID = env('APP_EMAIL_CODE_VALID')


class Prod(Dev):
    DEBUG = False

    # Security headers
    CSRF_COOKIE_SECURE = True
    # SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
    SESSION_COOKIE_SECURE = True
    # SECURE_SSL_REDIRECT = True
    # SECURE_HSTS_SECONDS = 31536000  # 1 year
    # SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    # SECURE_HSTS_PRELOAD = True

    if os.path.exists("/var/log/task_app"):
        LOGGING = {
            "version": 1,
            "disable_existing_loggers": False,
            "formatters": {
                "verbose": {
                    "format": "{levelname} {asctime} {module} {process:d} {thread:d} {message}",
                    "style": "{",
                },
            },
            "handlers": {
                "logfile": {
                    "class": "logging.FileHandler",
                    "filename": "/var/log/task_app/app.log",
                    "formatter": "verbose",
                },
            },
            "root": {
                "handlers": ["logfile"],
                "level": "ERROR",
            }
        }

    SIMPLE_JWT = {
        'UPDATE_LAST_LOGIN': True,
        "ACCESS_TOKEN_LIFETIME": timedelta(hours=1),
        "REFRESH_TOKEN_LIFETIME": timedelta(days=1),
        "ALGORITHM": 'RS256',
        "SIGNING_KEY": Dev.RSAkey.exportKey(),
        "VERIFYING_KEY": Dev.RSAkey.publickey().exportKey()
    }

    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
    # It is setup for gmail
    EMAIL_HOST = env('APP_EMAIL_HOST')
    EMAIL_USE_TLS = True
    EMAIL_PORT = env('APP_EMAIL_PORT')
    EMAIL_HOST_USER = env('APP_EMAIL_HOST_USER')
    EMAIL_HOST_PASSWORD = env('APP_EMAIL_HOST_PASSWORD')
