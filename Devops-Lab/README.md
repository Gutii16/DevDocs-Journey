# Estructura para el laboratorio sobre devops

📦 devops-lab
├── 📂 docs              # Documentación y guías
│   ├── setup.md        # Pasos de instalación
│   ├── kubernetes.md   # Notas sobre Kubernetes
│   ├── helm.md         # Notas sobre Helm
│   ├── ci-cd.md        # Notas sobre CI/CD
│   ├── monitoring.md   # Notas sobre monitoreo
├── 📂 kubernetes        # Archivos YAML para Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── namespace.yaml
├── 📂 terraform         # Infraestructura como código
│   ├── main.tf         # Definición de infraestructura
│   ├── variables.tf    # Variables de configuración
│   ├── outputs.tf      # Salida de Terraform
├── 📂 ansible          # Scripts para automatizar instalación
│   ├── playbook.yml
│   ├── inventory.ini
├── 📂 helm             # Charts personalizados
│   ├── mychart/
│   ├── values.yaml
├── 📂 scripts          # Scripts útiles (Bash, Python, etc.)
│   ├── setup-cluster.sh
│   ├── deploy-app.sh
├── .gitignore          # Archivos a ignorar
├── README.md           # Introducción al proyecto