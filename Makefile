
catkin_ws := catkin_ws
scuderia := scuderia.yaml
machines := $(catkin_ws)/src/duckietown/machines

all: $(machines)


$(machines): $(scuderia)
	python setup/create-machines-file.py $(scuderia) > $(machines)

fix-time:
	echo "Calling ntpdate to fix time"
	sudo ntpdate -u us.pool.ntp.org 

catkin-clean:
	rm -rf $(catkin_ws)/build

build-parallel:
	catkin_make -C $(catkin_ws) --make-args "-j4"
	
build:
	catkin_make -C $(catkin_ws) 

# Unit tests
# Teddy: make it so "make unittests" runs all unit tests

unittests-environment:
	bash -c "source environment.sh; python setup/sanity_checks"

unittests:
	$(MAKE) unittests-environment
	bash -c "source environment.sh; catkin_make -C $(catkin_ws) run_tests; catkin_test_results $(catkin_ws)/build/test_results/"


unittests-anti_instagram:
	$(MAKE) unittests-environment
	bash -c "source environment.sh; rosrun anti_instagram annotation_tests.py"

# HW testing 

test-camera:
	echo "Testing Camera HW by taking a picture (smile!)."
	raspistill -t 1000 -o test-camera.jpg


test-led:	
	bash -c "source environment.sh; rosrun rgb_led blink test_all_1"




# Basic demos

vehicle_name=$(shell hostname)

demo-joystick:	
	bash -c "source environment.sh; source set_ros_master.sh; source set_vehicle_name.sh; roslaunch duckietown joystick.launch veh:=$(VEHICLE_NAME)"

demo-joystick-camera:
	bash -c "source environment.sh; source set_ros_master.sh; source set_vehicle_name.sh; roslaunch duckietown joystick_camera.launch veh:=$(VEHICLE_NAME)"

demo-line_detector:
	bash -c "source environment.sh; roslaunch duckietown line_detector.launch veh:=emma"
  
demo-led-blink-%:	
	bash -c "source environment.sh; rosrun rgb_led blink $*"

demo-led-fancy1:	
	bash -c "source environment.sh; rosrun rgb_led fancy1"

demo-led-fancy2:	
	bash -c "source environment.sh; rosrun rgb_led fancy2"


