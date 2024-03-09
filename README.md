# README

## Versões 
* ruby 3.3.0 e Rails 7.1.3


#### Para levantantar a a aplicação recomendo o comando
```bash
  bin/dev
```

####  Ou levante cada serviço separadamente:

iniciar o servidor de desenvolvimento
```bash
  bin/rails server -p 3000
```
iniciar o watcher do Tailwind CSS
```bash
  bin/rails tailwindcss:watch
```
Iniciar o processador de jobs do GoodJob
```bash
  bundle exec good_job start
```
inicia um loop que executa o job que atualiza os status dos boletos 
```bash
  ruby clock.rb
```
## [Documentação da kobana.](https://developers.kobana.com.br/reference/visao-geral)
