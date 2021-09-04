
from flask import Flask , request , jsonify ,session 
from app import app , db
from models import User , storyitem , story
import json
import tensorflow as tf
import tensorflow_hub as hub
import tensorflow_text as text
from official.nlp import optimization
import os 
from flask import send_file

model = tf.keras.models.load_model(('finalModelText.h5'),custom_objects={'KerasLayer':hub.KerasLayer})

@app.route('/') 
def home():


    return 'Mail sent' 


    
@app.route('/API/login', methods=['POST'])
def login():
    request_data= request.data
    request_data=json.loads(request_data.decode('utf-8'))
    username = request_data['username']
    password = request_data['password'] 
    msg = ""
    if not username or not password : 
        msg = {"status" : { "type" : "failure" ,   "message" : "Missing Data"}}
        return jsonify(msg)
    
    user = User.query.filter_by(username=username).first() 
    if user is None or not user.check_password(password) :
        msg = {"status" : { "type" : "failure" ,   "message" : "Username or password incorrect"}}
    else:
        msg = {"status" : { "type" : "success" ,
                             "message" : "You logged in"} , 
               "data" : {"user" : user.getJsonData() }
        }

    return jsonify(msg)

@app.route('/API/register', methods=['POST'])
def register():
    request_data= request.data
    request_data=json.loads(request_data.decode('utf-8'))
    username = request_data['username']
    childName =request_data['childName']
    password = request_data['password'] 
    email = request_data['email'] 
    u=User.query.filter_by(username=username).first()


    msg = ""
    if not username or not password or not email or not childName : 
        msg = {"status" : { "type" : "failure" ,   "message" : "missing data"}}
        return jsonify(msg)
    
    if User.query.filter_by(username=username).count() == 1 : 
        msg = {"status" : { "type" : "failure" ,   "message" : "username already taken"}}
        return jsonify(msg)
    
    if User.query.filter_by(email=email).count() == 1 : 
        msg = {"status" : { "type" : "failure" ,   "message" : "email already taken"}}
        return jsonify(msg)
    
    u = User()
    u.username = username 
    u.childName = childName
    u.email = email 
    u.set_password(password) 

    db.session.add(u)
    db.session.commit() 

    msg = {"status" : { "type" : "success" ,   "message" : "You have registered"}}
    return jsonify(msg)

@app.route('/API/textClassifier', methods=['POST'])
def textClassifier():

    request_data= request.data
    request_data=json.loads(request_data.decode('utf-8'))
    text = request_data['text']
    username=request_data['username']
    result=model.predict([text])
    result_text=""
    if(result[0][0]>0):
        result_text="Positive"
        AddStory(username=username,text=text)
        d.generate_images(textt=text,username=username)
        #genrate_images(username=username,text=text)
    else :
        result_text="Negative"
    msg={"status" : { "type" : "success" ,   "message" : result_text}}
    return jsonify(msg)
    
def AddStory(username,text=text):

    u=User.query.filter_by(username=username).first()
    current_directory = os.getcwd()
    path_for_user_folder = os.path.join(current_directory, "story/"+u.username)
    if not os.path.exists(path_for_user_folder):
        os.mkdir(path_for_user_folder)
    path_for_story_folder = os.path.join(path_for_user_folder, text)
    if not os.path.exists(path_for_story_folder):
        os.mkdir(path_for_story_folder)
    


    msg={"status" : { "type" : "success" ,   "message" : text}}
    return jsonify(msg)

@app.route('/API/getstory', methods=['GET'])
def getstories():
    # here we want to get the value of user (i.e. ?user=some-value)
    user = request.args.get('user')
    data = []
    u=User.query.filter_by(username=user).first() 
    if(not u==None) :
        userStory = story.query.filter_by(user_id=u.id).all()
        for storyy in userStory:
            data.append({
                "title" : storyy.story_Title,
                "array":
                [
                    {
                        "text": storyy.stories_items[0].text,
                        "image": storyy.stories_items[0].path_Image,
                    },
    {
                        "text": storyy.stories_items[1].text,
                        "image":storyy.stories_items[1].path_Image,
                    }
                ]
            }
                


            )
        

    if( u==None) :
        msg={"status" : { "type" : "success" ,   "data" :"null",}}
    else :
        msg={"status" : { "type" : "success" ,   "data" :data,

        
    }}
    return jsonify(msg)
    

@app.route('/API/down', methods=['GET'])
def download():
    # here we want to get the value of user (i.e. ?user=some-value)
    path = request.args.get('path')
    return send_file(path, as_attachment=True)
    

from DalleLoader import *
d = DalleLoader()
