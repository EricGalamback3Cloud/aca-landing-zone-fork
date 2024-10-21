import time
import json
import random
import datetime
from flask import Flask, jsonify
from dapr.clients import DaprClient
import threading
import logging

logging.basicConfig(level=logging.INFO)
logging.info('Publisher starting')

app = Flask(__name__)

# Initialize Dapr client
dapr_client = DaprClient()

# Define the pub/sub topic
PUBSUB_NAME = "asbPubSub"  # Replace with your Dapr pubsub component name
TOPIC_NAME = "pipeline-pressure"  # The topic to which the messages are published

# Function to generate fake pressure readings and publish them every 5 seconds
def publish_fake_pressure_data():
    while True:
        logging.info('Publishing fake data')
        try:
            # Generate a fake pressure reading
            pressure = round(random.uniform(90.0, 110.0), 2)  # Fake pressure between 90.0 and 110.0

            # Create a message payload with the current timestamp
            payload = {
                "pressure": pressure,
                "timestamp": datetime.datetime.now(datetime.UTC).isoformat()
            }

            # Publish the message to the topic
            dapr_client.publish_event(
                pubsub_name=PUBSUB_NAME,
                topic_name=TOPIC_NAME,
                data=json.dumps(payload),
                data_content_type="application/json"
            )

            logging.info("published: " + json.dumps(payload))

            # Sleep for 5 seconds before publishing the next reading
            time.sleep(5)

        except Exception as e:
            print(f"Error publishing message: {e}")

# Flask route for health check
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

# Start publishing fake data in a separate thread
def start_publishing_thread():
    publishing_thread = threading.Thread(target=publish_fake_pressure_data)
    publishing_thread.daemon = True  # Ensure it exits when the main program exits
    publishing_thread.start()

if __name__ == '__main__':
    # Start the fake data publishing in a separate thread
    start_publishing_thread()

    # Start the Flask server for the health check
    app.run(port=8111)
