if ls -la $HOME | grep -ce .kube; then mv $HOME/.kube $HOME/goinfre/.; ln -s $HOME/.kube $HOME/goinfre/.kube; else echo "\033[1;4;31mNothing found make sure you ran minikube the first time.";fi

if ls -la $HOME | grep -ce .docker; then mv $HOME/.docker $HOME/goinfre/.; ln -s $HOME/.docker $HOME/goinfre/.docker; else echo "\033[1;4;31mNothing found make sure you ran minikube the first time.";fi