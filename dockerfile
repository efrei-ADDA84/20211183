FROM python:3.9

COPY weather.py /app/
COPY .env /app/
WORKDIR /app

RUN python -m pip install --upgrade pip

RUN pip install --upgrade setuptools
RUN pip install requests
RUN pip install python-dotenv
RUN pip install --upgrade python-dotenv

CMD ["python", "weather.py"]
