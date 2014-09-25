# Pull repository from private github repos

### Create .ssh dir in home directory
RUN mkdir -p /root/.ssh
ADD url_for_id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
 
# Pull project
RUN git clone git@github.com:Private/githubRepo.git /home/githubRepo