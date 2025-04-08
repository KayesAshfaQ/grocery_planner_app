#!/usr/bin/env bash

read -p "Enter feature name: " feature

mkdir -p "./lib/features/$feature/domain/entities"
mkdir -p "./lib/features/$feature/domain/repositories"
mkdir -p "./lib/features/$feature/domain/usecases"
mkdir -p "./lib/features/$feature/data/datasources"
mkdir -p "./lib/features/$feature/data/datasources/local"
mkdir -p "./lib/features/$feature/data/datasources/remote"
mkdir -p "./lib/features/$feature/data/models"
mkdir -p "./lib/features/$feature/data/repositories"
mkdir -p "./lib/features/$feature/presentation/blocs"
mkdir -p "./lib/features/$feature/presentation/pages"
mkdir -p "./lib/features/$feature/presentation/widgets"

touch "./lib/features/$feature/domain/entities/.gitkeep"
touch "./lib/features/$feature/domain/repositories/.gitkeep"
touch "./lib/features/$feature/domain/usecases/.gitkeep"
touch "./lib/features/$feature/data/datasources/local/.gitkeep"
touch "./lib/features/$feature/data/datasources/remote/.gitkeep"
touch "./lib/features/$feature/data/models/.gitkeep"
touch "./lib/features/$feature/data/repositories/.gitkeep"
touch "./lib/features/$feature/presentation/blocs/.gitkeep"
touch "./lib/features/$feature/presentation/pages/.gitkeep"
touch "./lib/features/$feature/presentation/widgets/.gitkeep"

echo "Feature '$feature' structure created."
