 ```python
from sqlalchemy import create_engine, Column, Integer, String, DateTime, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

Base = declarative_base()

class Action(Enum):
    ALLOW = 'allow'
    DENY = 'deny'

class Log(Base):
    __tablename__ = 'Log'
    id = Column(Integer, primary_key=True)
    src_ip = Column(String(15), nullable=False)
    dst_ip = Column(String(15), nullable=False)
    protocol = Column(String(10), nullable=False)
    action = Column(Enum(Action), nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow)

class Rule(Base):
    __tablename__ = 'Rule'
    id = Column(Integer, primary_key=True)
    ip = Column(String(15), nullable=False)
    action = Column(Enum(Action), nullable=False)

# Database setup
engine = create_engine('sqlite:///example.db', echo=True)
Base.metadata.create_all(engine)
Session = sessionmaker(bind=engine)
session = Session()

# Example usage
new_log = Log(src_ip='192.168.1.1', dst_ip='10.0.0.1', protocol='TCP', action=Action.ALLOW)
session.add(new_log)
session.commit()
```
