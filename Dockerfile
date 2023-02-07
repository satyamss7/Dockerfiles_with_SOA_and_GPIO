FROM ubuntu:22.04
LABEL Description="SDV someip SOA minimal"

ENV HOME /home/work

RUN apt-get update && apt-get -y --no-install-recommends install \
  	build-essential \
    	clang \
       	cmake \
	git \
	vim \
    	asciidoc \
	pkg-config \
	libboost-all-dev \
	net-tools \
	iputils-ping \
	ca-certificates \
	apt-utils

#RUN apt-get install -y minicom

RUN mkdir -p /home/work

WORKDIR ${HOME}

RUN git clone https://github.com/COVESA/vsomeip.git &&\
	cd vsomeip &&\
   	mkdir build && cd build &&\
        cmake .. ;\
        make ;\
        make install ;\
        cmake --build . --target examples ;\
        ldconfig  
#RUN pip install rpi.gpio 

RUN cd /home/work/vsomeip/examples &&\
	git clone https://github.com/gbmhunter/CppLinuxSerial &&\
	cd CppLinuxSerial &&\
	mkdir build &&\
	cd build &&\
	cmake .. ;\
	make ;\
	make install
RUN git clone https://github.com/satyamss7/modified_notify_and_subscribe_GPIO.git
RUN cp -fr /home/work/modified_notify_and_subscribe_GPIO/* /home/work/vsomeip/examples/
RUN cd /home/work/vsomeip/build/ &&\
	cmake .. ;\
	make ;\
	make install ;\
	cmake --build . --target examples ;\
	ldconfig

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
        
       
        
