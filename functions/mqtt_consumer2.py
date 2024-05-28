import paho.mqtt.client as mqtt
import wave
import numpy as np
import firebase_admin
from firebase_admin import credentials, firestore, storage
import os

received_data = bytearray()
expected_data_length = 0

cred = credentials.Certificate("/Users/tarasgrudzinskij/Documents/studying/дипломна/sensory_alarm/functions/credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
storage_bucket_name = "sensory-alarm.appspot.com"
bucket = storage.bucket(storage_bucket_name)

deviceId = "4c1307b1-7630-4528-bed1-7c38b907d508"  
userId = "GoTbGvktC3fbm61fFmFEbbdBxmZ2"

def on_message(client, userdata, message):
    global received_data, expected_data_length
    
    print("Received message with topic:", message.topic)
    print("Received data:", message.payload)

    if message.topic == "test/audio_file_size":
        expected_data_length = int(message.payload.decode('utf-8').strip('\x00'))
        print("Expected data length:", expected_data_length)
    elif message.topic == "test/topic":
        print('test/topic прочитався')
        received_data.extend(message.payload)
        print('message.payload: ', message.payload)
        print('received_data.length: ', len(received_data))

        if len(received_data) >= expected_data_length:
            create_wav_file(received_data, "received_audio_test.wav")
            upload_to_firebase_storage("received_audio_test.wav")
            received_data.clear()

def create_wav_file(data, filename):
    channels = 1
    sample_width = 2
    frame_rate = 16000 

    with wave.open(filename, 'wb') as wav_file:
        wav_file.setnchannels(channels)
        wav_file.setsampwidth(sample_width)
        wav_file.setframerate(frame_rate)
        wav_file.writeframes(data)

    print("Audio file saved as", filename)

def upload_to_firebase_storage(filename):
    blob = bucket.blob(filename)
    blob.upload_from_filename(filename)
    audio_url = blob.public_url
    print(f"Uploaded {filename} to Firebase Storage")

    doc_ref = db.collection(u'users').document(userId).collection(u'devices').document(deviceId).collection(u'events').document()
    doc_ref.set({
        u'audioUrl': audio_url
    })

    print("Audio URL '{}' added to Firestore".format(audio_url))

    os.remove(filename)
    print(f"Local file {filename} removed")

client = mqtt.Client()
client.on_message = on_message
client.username_pw_set("tarastest", "12qwASzx!")
client.connect("192.168.0.101", 1883, 60)

client.subscribe("test/audio_file_size")
client.subscribe("test/topic")

client.loop_forever()