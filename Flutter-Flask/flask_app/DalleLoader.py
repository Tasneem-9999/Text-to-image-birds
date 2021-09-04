
from models import User , storyitem , story
from app import  db

import torch
from torchvision.utils import save_image
import gc
gc.collect()
torch.cuda.empty_cache()
import os
os.environ["CUDA_DEVICE_ORDER"]="PCI_BUS_ID"
os.environ["CUDA_VISIBLE_DEVICES"]="0"

import torch.nn.functional as F
from torchvision.utils import make_grid , save_image 
from dalle_pytorch import VQGanVAE1024, DALLE
from tokenizers import Tokenizer

import matplotlib.pyplot as plt
from matplotlib.pyplot import figure
from PIL import Image
import numpy as np
import clip
import ftfy
import requests
  
class DalleLoader:

 
    dalle=None
    vocab=None
    dalle_dict=None
    def __init__(self):
        BPE_path = "BPE/cub200_bpe_vsize_7800.json"
        dalle_path = "cub200_adam_frcc.pth"
        vae_dict = {"args": {"image_size": 256, "emb_dim": 256}}
        self.vocab = Tokenizer.from_file(BPE_path)
        self.dalle_dict = torch.load(dalle_path)
        vae=VQGanVAE1024()
        attn_types = []
        for type in self.dalle_dict['args']['attn_types'].split(","):
            assert type in ("full", "sparse", "axial_row", "axial_col", "conv_like")
            attn_types.append(type)
        attn_types = tuple(attn_types)
        print("[Log] Attention types: ", attn_types)
        self.dalle = DALLE(
                dim=vae_dict['args']['emb_dim'],
                vae=vae,
                num_text_tokens=self.dalle_dict['args']['num_text_tokens'],
                text_seq_len=self.dalle_dict['args']['text_seq_len'],
                depth=self.dalle_dict['args']['depth'],
                heads=self.dalle_dict['args']['heads'],
                reversible=self.dalle_dict['args']['reversible'],
                attn_types=attn_types,
        ).cuda()        
        self.dalle.load_state_dict(self.dalle_dict['dalle'])
    def generate_images(self,textt,username):
        textt=textt.rstrip()
        u=User.query.filter_by(username=username).first()
        for x in range(3):
                input_text = [textt] * 4

                token_list = []
                sot_token = self.vocab.encode("<|startoftext|>").ids[0]
                eot_token = self.vocab.encode("<|endoftext|>").ids[0]
                for txt in input_text:
                    codes = [0] * self.dalle_dict['args']['text_seq_len']
                    text_token = self.vocab.encode(txt).ids
                    tokens = [sot_token] + text_token + [eot_token]
                    codes[:len(tokens)] = tokens
                    caption_token = torch.LongTensor(codes).cuda()
                    token_list.append(caption_token)
                text = torch.stack(token_list)
                mask = (text != 0).cuda()

                images = self.dalle.generate_images(text, mask = mask, filter_thres = 0.9, temperature=1.0, num_init_img_tokens=2)
                #save_image(images, "temp/"+"image_"+str(x)+txt+".png")
                torch.save(images,"temp/"+"image_"+str(x)+"_"+txt)

        for x in range(2):
            i=torch.load("temp/"+"image_"+str(x)+"_"+textt)
            images= torch.cat((images,i),0)
    
            
        #clip
        device = "cuda" if torch.cuda.is_available() else "cpu"
        model, preprocess = clip.load("ViT-B/32", device=device)
        """ Get rank by CLIP! """
        image = F.interpolate(images, size=224)
        text = clip.tokenize([textt]).to(device)

        with torch.no_grad():
            image_features = model.encode_image(image)
            text_features = model.encode_text(text)
            
            logits_per_image, logits_per_text = model(image, text)
            probs = logits_per_text.softmax(dim=-1).cpu().numpy()

        print("Label probs:", probs)

        np_images = images.cpu().numpy()
        scores = probs[0]

        #def show_reranking(images, scores, sort=True):
        sort=True
        img_shape = np_images.shape
        if sort:
            scores_sort = scores.argsort()
            scores = scores[scores_sort[::-1]]
            np_images = np_images[scores_sort[::-1]]

        t = torch.from_numpy(np_images)
        print("Label scores:", scores)
        print("tensor is", scores_sort)

        save_image(t[0], "story/"+username+"/"+textt+"/"+"image_1_"+str(scores[0])+".jpg")
        save_image(t[1], "story/"+username+"/"+textt+"/"+"image_2_"+str(scores[1])+".jpg")
        #save_image(t[11], "story/"+username+"/"+textt+"/"+"image_11_"+str(scores[11])+".jpg")
    
        u.stories.append(story(story_Title=textt))
    ## here we will get string and image form dalle model 
        
        y_text = 'bird'
        if 'bird' in textt :
            y_text="bird"
        if 'parrot' in textt :
            y_text="parrot"
        if 'woodpecker' in textt :
            y_text= "woodpecker"
        if 'pigeon' in textt :
            y_text="pigeon"
        if 'auklet' in textt:
            y_text="auklet"

        #https://api.dictionaryapi.dev/api/v2/entries/en/word
        f = requests.get('https://api.dictionaryapi.dev/api/v2/entries/en/'+y_text).json()



        #https://api.dictionaryapi.dev/api/v2/entries/en/word
        #f = requests.get('https://api.dictionaryapi.dev/api/v2/entries/en/bird').json()
    

        storyy =story.query.filter_by(story_Title=textt).first()
        storyy.stories_items=[storyitem(text=textt, path_Image="story/"+u.username+"/"+textt+"/image_1_"+str(scores[0])+".jpg"),
        storyitem(text=f[0]["meanings"][0]["definitions"][0]['definition'], path_Image="story/"+u.username+"/"+textt+"/image_2_"+str(scores[1])+".jpg")]
                    

        db.session.commit() 
                                                                                








# make DALLE ready
# Reformat attention types

#load dalle model weights



'''
import clip
device = "cuda" if torch.cuda.is_available() else "cpu"
model, preprocess = clip.load("ViT-B/32", device=device)
""" Get rank by CLIP! """
import ftfy
image = F.interpolate(images, size=224)
text = clip.tokenize(["this colorful bird has a red breast , with a white crown and a black cheek patch."]).to(device)

with torch.no_grad():
    image_features = model.encode_image(image)
    text_features = model.encode_text(text)
    
    logits_per_image, logits_per_text = model(image, text)
    probs = logits_per_text.softmax(dim=-1).cpu().numpy()

print("Label probs:", probs)

np_images = images.cpu().numpy()
scores = probs[0]

def show_reranking(images, scores, sort=True):
    img_shape = images.shape
    if sort:
        scores_sort = scores.argsort()
        scores = scores[scores_sort[::-1]]
        images = images[scores_sort[::-1]]


save_image(images[14], 'img1.png')
save_image(images[13], 'img2.png')
'''