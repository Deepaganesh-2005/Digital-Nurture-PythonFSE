from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# =========================================================
# DATABASE CONFIGURATION
# =========================================================

USERNAME = "root"
PASSWORD = "root000"
HOST = "localhost"
PORT = 3306
DATABASE = "college_db_orm"

# =========================================================
# DATABASE URL
# =========================================================

DATABASE_URL = (
    f"mysql+mysqlconnector://{USERNAME}:{PASSWORD}"
    f"@{HOST}:{PORT}/{DATABASE}"
)

# =========================================================
# CREATE ENGINE
# =========================================================

engine = create_engine(
    DATABASE_URL,
    echo=True,
    future=True
)

# =========================================================
# SESSION FACTORY
# =========================================================

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False
)

# =========================================================
# BASE CLASS
# =========================================================

Base = declarative_base()

# =========================================================
# GET DATABASE SESSION
# =========================================================

def get_session():
    """
    Returns a new SQLAlchemy session.
    """
    return SessionLocal()

# =========================================================
# TEST DATABASE CONNECTION
# =========================================================

if __name__ == "__main__":

    try:

        session = get_session()

        print("=" * 50)
        print("Connected Successfully")
        print(f"Database : {DATABASE}")
        print("=" * 50)

        session.close()

    except Exception as error:

        print("=" * 50)
        print("Connection Failed")
        print(error)
        print("=" * 50)