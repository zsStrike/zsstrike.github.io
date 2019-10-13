# push code to hexo-project
git add .
git commit -m "auto push via push_and_deploy.sh"
git push origin hexo-project
# deploy origin master
hexo clean
hexo g -d
# pause
read -n1 -p "Press any key to continue..."
