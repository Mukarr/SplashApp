# The standard library modules
import os
import sys

# The BeautifulSoup module
from bs4 import BeautifulSoup

# The selenium module
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains

#New firefox profile to set certain preperences
firefoxProfile = webdriver.FirefoxProfile();

firefoxProfile.set_preference("browser.download.folderList",2);
firefoxProfile.set_preference("browser.download.manager.showWhenStarting",False);
firefoxProfile.set_preference("browser.download.dir","~/Desktop/Wallpapers"); #download to the specified folder
firefoxProfile.set_preference("browser.helperApps.neverAsk.saveToDisk","image/jpg"); #download without asking

driver = webdriver.Firefox(firefox_profile=firefoxProfile);

driver.get("https://quotefancy.com/motivational-quotes") # load the web page
print("At the webpage!")
WebDriverWait(driver, 50).until(EC.visibility_of_element_located((By.ID, "wall18846"))) # waits till the element with the specific id appears
elems =[]
elems = driver.find_elements_by_class_name("dl-wrapper") # Find all the download buttons

for elem in elems:
	link = elem.find_element_by_css_selector('a').get_attribute('href') # find the download link
	#print(link)
	driver.implicitly_wait(20) # seconds
	driver.get(link)	


driver.get("https://quotefancy.com/mark-twain-quotes") # load the web page
print("At the webpage!")
WebDriverWait(driver, 50).until(EC.visibility_of_element_located((By.ID, "wall18846"))) # waits till the element with the specific id appears
elem =[]
elem = driver.find_elements_by_class_name("dl-wrapper") # Find the edownload button

for elems in elem:
	link = elems.find_element_by_css_selector('a').get_attribute('href') # find the download link
	#print(link)
	driver.get(link)	
