# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.10.5
FROM python:${PYTHON_VERSION} as base

# Install Rust compiler
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# 🛠️ First copy only requirements.txt (for caching benefits)
COPY requirements.txt .

# ✅ Now install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# 📦 Then copy the rest of the app
COPY . .

# Expose the port
EXPOSE 8000

# Run the app
CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
