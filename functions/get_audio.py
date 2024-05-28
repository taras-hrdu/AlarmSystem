# import requests

# def download_audio(url, save_path):
#     response = requests.get(url)
#     if response.status_code == 200:
#         with open(save_path, 'wb') as f:
#             f.write(response.content)
#         print("Аудіофайл успішно збережено як", save_path)
#     else:
#         print("Не вдалося завантажити аудіофайл")

# audio_url = "http://192.168.0.117/recording.wav"

# # save_path = "recording.wav"
# save_path = "/Users/tarasgrudzinskij/recording.wav"

# download_audio(audio_url, save_path)

import requests
import firebase_admin
from firebase_admin import credentials, firestore, storage
import datetime

cred = credentials.Certificate("/Users/tarasgrudzinskij/Documents/studying/дипломна/sensory_alarm/functions/credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
storage_bucket_name = "sensory-alarm.appspot.com"
bucket = storage.bucket(storage_bucket_name)

deviceId = "4c1307b1-7630-4528-bed1-7c38b907d508"  
userId = "GoTbGvktC3fbm61fFmFEbbdBxmZ2"

def upload_audio_to_firebase_storage(url, remote_file_path):
    response = requests.get(url)
    if response.status_code == 200:
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        remote_file_path = f"{remote_directory}/recording_{timestamp}.wav"
        blob = bucket.blob(remote_file_path)
        blob.upload_from_string(response.content, content_type='audio/wav')        
        audio_url = blob.public_url
        doc_ref = db.collection(u'users').document(userId).collection(u'devices').document(deviceId).collection(u'events').document()
        doc_ref.set({
            u'audioUrl': audio_url
        })

        print("Audio URL '{}' added to Firestore".format(audio_url))

    else:
        print("Не вдалося завантажити аудіофайл")

audio_url = "http://192.168.0.117/recording.wav"
remote_directory = "audio"

upload_audio_to_firebase_storage(audio_url, remote_directory)

