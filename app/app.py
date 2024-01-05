from flask import Flask, jsonify
import boto3
import json
import os

app = Flask(__name__)

def read_s3_json(bucket_name, key):
    s3 = boto3.client('s3')
    try:
        return json.loads(s3.get_object(Bucket=bucket_name, Key=key)['Body'].read().decode('utf-8'))
    except Exception as e:
        return f"Error: {e}"

# Use environment variables for bucket name and file key
bucket_name = os.environ.get('S3_BUCKET_NAME', 'default-bucket')
file_key = os.environ.get('S3_FILE_KEY', 'default-file.json')

@app.route('/api/message')
def display_json():
    return jsonify(read_s3_json(bucket_name, file_key))

if __name__ == '__main__':
    app.run(debug=True, port=8000)
