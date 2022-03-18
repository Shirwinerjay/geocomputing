# Custom notebooks image for Notebooks 5 (currently in beta)

These instructions guide you throught the process of creating Jupyter notebooks for a course with custom conda packages installed. 

Requirements: 
* own CSC user account with Rahti access
* docker installed (own computer or Pouta instance)

## Step-by-step

1. Become a workspace owner
Send your CSC user account name to `notebooks@csc.fi` to request Notebooks workspace owner rights.

2. Login to https://notebooks-beta.rahtiapp.fi/welcome

3. Check that you got workspace ower rights
It worked, if you see 'Manage workspaces' tab in the left panel

4. Create custom notebooks image
If you cannot use any of the [provided images](https://github.com/CSCfi/notebook-images/tree/master/builds) but want to use your own notebooks image, you will need to create an image using Docker and host it on Rahti.

4.1 Create Docker file

For Jupyter Lab with some conda packages use the following as minimal example:

xxcourse.dockerfile:

```text 
# use jupyter minimal notebook as base for your image, it has eg conda already installed
FROM jupyter/minimal-notebook

# add your name as maintainer, with your email address for future questions
LABEL maintainer="your-name-here"

#some first setup steps need to be run as root user
USER root

# set home environment variable to point to user directory
ENV HOME /home/$NB_USER

# install needed extra tools, eg ssh-client and less
RUN apt-get update \
    && apt-get install -y ssh-client less \
    && apt-get clean

# the user set here will be the user that students will use when working in the notebook
USER $NB_USER

### Installing the needed conda packages  and jupyter lab extensions . And run conda clean afterwards in same layer to keep image size lower
RUN conda install --yes -c conda-forge \
  your-packages-here \
  && conda clean -afy

```

4.2 Build the image from dockerfile to current directory (.)
`docker build -t "<yourimagename>" -f <yourimagename>.dockerfile .`

4.3 Send your image to Rahti registry

* Login to https://registry-console.rahti.csc.fi/ 

* Find the `login commands` on the `Overview` page and use one of them to login to Rahti registry from command line

* Create a new project on Rahti webpage (or re-use one that you already have)

* Tag your docker image, eg based on versions (here: v0.1):

`sudo docker tag <yourimagename> docker-registry.rahti.csc.fi/<yourrahtiproject>/<yourimagename>:v0.1`

* Push your docker image to Rahti registry:

`sudo docker push docker-registry.rahti.csc.fi/<yourrahtiproject>/<yourimagename>`

4.4 In Notebooks: Create a workspace and within that, create new application
Notebooks > Manage workspaces using the `Application wizard` or `Application form`

* Choose any `Application template` (check for different basic settings (lifetime and memory))

* Give a meaningful `Application name` , eg `Geospatial Python course 2022`, this is the name under which participants will see the notebook in the list of notebooks

* Add a short `Description`

* Add/remove `Category labels` that fit with your notebook

* Choose if you want Jupyter Lab or Jupyter Notebooks interface

* Fill in the link to your image on Rahti under `Container image` ( You can find the link from Rahti web interface > projectname > imagename > Pulling repository, e.g. `docker-registry.rahti.csc.fi/<yourprojectname>/<yourimagename>:<tagyouwanttouse>`

* Choose a `download method` if you want to download files at notebook startup directly into students home directory, e.g. code used during the course that is available on github

* Choose if you want to have a persistent my-work folder for each student (nice for multiday courses, when students create files during the course)

* Choose if you want to publish or save as draft for testing. Publish means that everyone with a join code could find it, but it will never appear for every notebooks user on the home page.

4.5 Test your application

4.6 Share the join code (Notebooks > Manage Workspaces > Join code) with course participants and co-instructors

4.7 Once the co-instructors/co-organizers have signed in, you can find their name in the 'members' tab (under 'manage workspaces'), to give them rights to change things and see other participants sessions, 'promote to co-owner' from the Menu column next to the members name.

