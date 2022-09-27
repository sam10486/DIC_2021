import numpy as np
from cv2 import cv2
from scipy import signal

def salt_pepper_noise(image, fraction, salt_vs_pepper):
    img = np.copy(image)
    size = img.size
    num_salt = np.ceil(fraction * size * salt_vs_pepper).astype('int')
    num_pepper = np.ceil(fraction * size * (1 - salt_vs_pepper)).astype('int')
    row, column = img.shape

    # 隨機的座標點
    x = np.random.randint(0, column - 1, num_pepper)
    y = np.random.randint(0, row - 1, num_pepper)
    img[y, x] = 0   # 撒上胡椒

    # 隨機的座標點
    x = np.random.randint(0, column - 1, num_salt)
    y = np.random.randint(0, row - 1, num_salt)
    img[y, x] = 255 # 撒上鹽
    return img

fraction = 0.02        # 雜訊佔圖的比例
salt_vs_pepper = 0.5  # 鹽與胡椒的比例

image_gray = cv2.imread('image.jpg', cv2.IMREAD_GRAYSCALE)

(w, h) = image_gray.shape
print('w =', w , 'h =', h)
cv2.imshow('Result', image_gray)

cv2.waitKey(0)
image_resize = cv2.resize(image_gray,(128, 128), interpolation = cv2.INTER_AREA)
(resize_w, resize_h) = image_resize.shape
print('resize_w =',resize_w , 'resize_h =', resize_h)
cv2.imshow('Resize', image_resize)
cv2.waitKey(0)

noise_img = salt_pepper_noise(image_resize, fraction, salt_vs_pepper)
(noise_w, noise_h) = noise_img.shape
print('noise_w =', noise_w , 'noise_h =', noise_h)
cv2.imshow('Noise', noise_img)
cv2.waitKey(0)

median_img = signal.medfilt(noise_img, 3).astype(np.uint8)


(median_w, median_h) = median_img.shape
print('median_w =', median_w , 'median_h =', median_h)
cv2.imshow('median', median_img)
cv2.waitKey(0)

print(type(noise_img))


np.savetxt('img.dat', noise_img, fmt='%x', delimiter='\n')
np.savetxt('golden.dat', median_img, fmt='%x', delimiter='\n')
