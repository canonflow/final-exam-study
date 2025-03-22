import tensorflow as tf
print("TensorFlow version:", tf.__version__)
print("Python version:", tf._sys.version)
print("GPU available:", tf.config.list_physical_devices('GPU'))
