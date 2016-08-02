from celery import Celery

app = Celery('tasks', backend='amqp',
                      broker='amqp://ubuntu:test@52.77.57.155/host')
@app.task
def add(x, y):
     return x + y

