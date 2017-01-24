# bacula

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with bacula](#setup)
    * [What bacula affects](#what-bacula-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with bacula](#beginning-with-bacula)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Este modulo foi criado para autoconfigurar o bacula nos clientes através do
puppet. 

**Testado**:
- CentOS

## Descrição do Módulo

Este módulo configura os clientes e servidores do Bacula 7. Cria arquivos de
Configurações para cada sessão como JobDefs, Schedule.

## Setup
cd /etc/puppet/modules git clone https://github.com/jonatanmenghetti/puppet-bacula.git

### What bacula affects

* Irá afetar a configurações existentes do bacula-fd, bacula-sd e bacula-client

## Usage

class {'bacula::dir':

}


## Limitations

This is where you list OS compatibility, version compatibility, etc.

Compatible with linux Versions: 
- CentOS 7

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
