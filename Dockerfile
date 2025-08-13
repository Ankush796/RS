FROM python:3.10-slim

# Install dependencies in one step
RUN apt-get update && apt-get install -y \
    wget \
    git \
    python3-pip \
    curl \
    bash \
    ffmpeg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install neofetch manually (Debian slim doesn't have it by default)
RUN git clone https://github.com/dylanaraps/neofetch.git /opt/neofetch \
    && ln -s /opt/neofetch/neofetch /usr/local/bin/neofetch

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir wheel && \
    pip3 install --no-cache-dir -U -r requirements.txt

# Copy project files
WORKDIR /app
COPY . .

EXPOSE 8000

# Start Flask and your script in foreground
CMD ["sh", "-c", "flask run -h 0.0.0.0 -p 8000 & exec python3 -m devgagan"]

