# import paho.mqtt.client as mqtt
# import firebase_admin
# from firebase_admin import credentials, firestore, storage
# import os

# cred = credentials.Certificate("/Users/tarasgrudzinskij/Documents/studying/дипломна/sensory_alarm/functions/credentials.json")
# firebase_admin.initialize_app(cred)
# db = firestore.client()
# storage_bucket_name = "sensory-alarm.appspot.com"
# bucket = storage.bucket(storage_bucket_name)

# def on_message(client, userdata, msg):
#     parts = msg.payload.decode().split("|")
#     message = parts[0]
#     userId = parts[1] 
#     deviceId = "4c1307b1-7630-4528-bed1-7c38b907d508"   

#     # Збереження аудіозапису в Firebase Storage
#     audio_file_path = "assets/sounds/sound1.wav"
#     audio_blob = bucket.blob(audio_file_path)
#     audio_blob.upload_from_filename(audio_file_path)
#     audio_url = audio_blob.public_url


#     # Збереження посилання на аудіозапис в Firestore
#     doc_ref = db.collection(u'users').document(userId).collection(u'devices').document(deviceId).collection(u'events').document()
#     doc_ref.set({
#         u'message': message,
#         u'audioUrl': audio_url
#     })

#     print("Message '{}' added to Firestore from topic '{}'".format(message, msg.topic))
#     print("UserId '{}' added to Firestore from topic '{}'".format(userId, msg.topic))
#     print("Audio URL '{}' added to Firestore from topic '{}'".format(audio_url, msg.topic))

# db = firestore.client()

# client = mqtt.Client()
# client.on_message = on_message
# client.username_pw_set("tarastest", "12qwASzx!")
# client.connect("192.168.0.100", 1883, 60)

# client.subscribe("test/topic")

# client.loop_forever()

import paho.mqtt.client as mqtt
import firebase_admin
from firebase_admin import credentials, firestore, storage
import requests
import datetime
import os

cred = credentials.Certificate("/Users/tarasgrudzinskij/Documents/studying/дипломна/sensory_alarm/functions/credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
storage_bucket_name = "sensory-alarm.appspot.com"
bucket = storage.bucket(storage_bucket_name)

audio_url = "http://192.168.0.110/recording.wav"
remote_directory = "audio"

def upload_audio_to_firebase_storage(url, remote_file_path, userId, deviceId, message):
    response = requests.get(url)
    if response.status_code == 200:
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        remote_file_path = f"{remote_directory}/recording_{timestamp}.wav"
        blob = bucket.blob(remote_file_path)
        blob.upload_from_string(response.content, content_type='audio/wav')        
        audio_url = blob.public_url
        doc_ref = db.collection(u'users').document(userId).collection(u'devices').document(deviceId).collection(u'events').document()
        doc_ref.set({
            u'message': message,
            u'audioUrl': audio_url
        })

        print("Audio URL '{}' added to Firestore".format(audio_url))
        print("Message '{}' added to Firestore".format(message))

    else:
        print("Не вдалося завантажити аудіофайл")

def on_message(client, userdata, msg):
    parts = msg.payload.decode().split("|")
    message = parts[0]
    userId = parts[1] 
    # deviceId = "4c1307b1-7630-4528-bed1-7c38b907d508"
    deviceId = "f6c21462-fad4-4c8b-864b-b40e03e2905a"   

    upload_audio_to_firebase_storage(audio_url, remote_directory, userId, deviceId, message)


db = firestore.client()

client = mqtt.Client()
client.on_message = on_message
client.username_pw_set("tarastest", "12qwASzx!")
client.connect("192.168.0.102", 1883, 60)

client.subscribe("test/topic")

client.loop_forever()
