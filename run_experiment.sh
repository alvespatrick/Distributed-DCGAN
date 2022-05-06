#!/bin/bash

mkdir cifar10 && cd cifar10
wget --no-check-certificate https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz
tar -xvf cifar-10-python.tar.gz
cd ..

./cifar10/ Falta criar o arquivo ainda

#Este comando só é necessario caso nao haja a imagem do docker na maquina
#docker build -t dist_dcgan .

rm  -r time_out.txt
for i in $(seq 1 3); do
	for num in 1 2 4 8; do
		START="$(date +"%s")"
		docker run --env OMP_NUM_THREADS=1 --rm --network=host -v=$(pwd):/root dist_dcgan:latest python -m torch.distributed.launch --nproc_per_node=$num --nnodes=1 --node_rank=0 --master_addr="172.17.0.1" --master_port=1234 dist_dcgan.py --dataset cifar10 --dataroot ./cifar10 --num_epochs=1 --batch_size=16
		END="$(date +"%s")"
		TIME="$((END - START))"
		echo $TIME "Proc=$num" >> time_out$i.txt
		rm -rf real_samples_rank_*
		rm -rf fake_samples_rank_*
	done
done
