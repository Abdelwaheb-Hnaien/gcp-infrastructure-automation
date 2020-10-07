#Import necessary functions from Jinja2 module
from jinja2 import Environment, FileSystemLoader

#Import YAML module
import yaml
import os

ENV = os.environ["ENV"]

#Load data from YAML into Python dictionary
config_data = yaml.load(open("/workspace/devops/cd/IaC/resources/config/"+ENV+"/config.yml"))

#Load Jinja2 template
env = Environment(loader = FileSystemLoader('/workspace/devops/cd/IaC/resources'), trim_blocks=True, lstrip_blocks=True)
main_template = env.get_template('main_template.tf')
main_output = main_template.render(config_data)
backend_config_template = env.get_template('backend_config_template.tf')
backend_config_output = backend_config_template.render(config_data)
#Render the template with data and print the output
print ('#-----------------------------------------------------------------------------#')
print ('#------------                    TERRAFORM IaC                  --------------#')
print ('#-----------------------------------------------------------------------------#')
print(main_output)
print (' ----------------------------------------------------------------------------- ')
print (backend_config_output)
print ('#-----------------------------------------------------------------------------#')
with open('main.tf', 'w') as f:
    f.write(main_output)
with open('backend_config.tf', 'w') as f:
    f.write(backend_config_output)
