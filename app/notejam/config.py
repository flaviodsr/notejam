import os
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    DEBUG = False
    TESTING = False
    SECRET_KEY = 'notejam-flask-secret-key'
    WTF_CSRF_ENABLED = True
    CSRF_SESSION_KEY = 'notejam-flask-secret-key'
    DB_DRIVER = os.getenv('DB_PASS', 'sqlite')
    if DB_DRIVER == 'mysql':
        MYSQL_USER = os.getenv('MYSQL_USER', 'root')
        MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', '')
        MYSQL_HOST = os.getenv('MYSQL_HOST', 'localhost')
        MYSQL_DB_NAME = os.getenv('MYSQL_DB_NAME', 'notejam')
        SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://' + MYSQL_USER + ':' + \
            MYSQL_PASSWORD + '@' + MYSQL_HOST + '/' + MYSQL_DB_NAME + '?charset=utf8'
    else:
        SQLALCHEMY_DATABASE_URI = 'sqlite:///' + \
            os.path.join(os.getenv('DATA_DIR', basedir), 'notejam.db')


class ProductionConfig(Config):
    DEBUG = False


class DevelopmentConfig(Config):
    DEVELOPMENT = True
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
    WTF_CSRF_ENABLED = False
