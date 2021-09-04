from werkzeug.security import generate_password_hash  , check_password_hash
from app import db 

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer , primary_key=True)

    username = db.Column(db.String(64) ,index=True,unique=True)
    childName = db.Column(db.String(100) ,index=True,unique=True)
    email = db.Column(db.String(120) ,index=True,unique=True)
    stories = db.relationship("story", backref='user')


    password_hash = db.Column(db.String(128))

    def set_password(self,password):
        self.password_hash = generate_password_hash(password)

    def check_password(self,password):
        return check_password_hash(self.password_hash , password)

    def getJsonData(self):
        return {"username" : self.username , 
                "childName" : self.childName , 
                "email" : self.email }
    
class story(db.Model):
    __tablename__ = 'story'
    id = db.Column(db.Integer , primary_key=True)

    story_Title = db.Column(db.String(64) ,index=True,unique=True)
    user_id = db.Column(db.Integer, db.ForeignKey( ('user.id')))
    stories_items = db.relationship("storyitem", backref='story')
    def addStoryItems(self,item ):
        s = storyitem(text=item.text,path_Image=item.path_Image)
        print(s.text)
        return s

        return {"storyTitle" : self.storyTitle , 
                "storyid" : self.storyid , 
              }
    def getJsonstory(self):
        return {"storyTitle" : self.storyTitle , 
                "storyid" : self.storyid , 
              }
    
class storyitem(db.Model):
    __tablename__ = 'storyitem'

    id = db.Column(db.Integer , primary_key=True)

    text = db.Column(db.String(64) ,index=True)
    path_Image = db.Column(db.String(100) ,index=True)

    story_id = db.Column(db.Integer, db.ForeignKey( ('story.id')))


    def getJsonData(self):
        return {"text" : self.text , 
                "path_Image" : self.path_Image , 
                 }
    