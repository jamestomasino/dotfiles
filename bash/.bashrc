# STARTUP SEQUENCE INSPIRED BY rc.d
#
# scripts are prefixed for order of startup by the following pattern
# 00 - must run first
# 10 - 
# 20 - 
# 30 - programming languges
# 40 - development environments
# 50 - shell utilities
# 60 - 
# 70 - 
# 80 - 
# 90 - must run last

for FN in $HOME/.bashrc.d/*.sh ; do
  . "$FN"
done
