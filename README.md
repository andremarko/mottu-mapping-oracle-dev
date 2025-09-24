
## First things first!

Antes de executar o script de criação da package `package_mottu_mapping.sql`, siga a ordem de execução:

- `ddl_mottu_mapping.sql` -> cria tabelas do projeto e trigger `afi_auditoria_tb_motorcycle`;
- `dml_mottu_mapping.sql` -> popula as tabelas;
- Suba para o seu schema a biblioteca `jbcrypt-0.4.jar`:

```
git clone https://github.com/andremarko/mottu-mapping-oracle-dev.git
cd mottu-mapping-oracle-dev
loadjava -u rm555285/270102@oracle.fiap.com.br:1521/orcl -v -r jbcrypt-0.4.jar
```

- Rode `package_mottu_mapping.sql` -> **ATENÇÃO** o primeiro utilitário se trata do `BcryptUtil`. Em seguida será criado o Package `mottu_mapping_pkg` Spec e o Body;
- Rode os cenários de testes `test_scenarios_mottu_mapping.sql`, qual utiliza a package e o seu conteúdo.

**Resumo de execução:**
- `ddl_mottu_mapping.sql`
- `dml_mottu_mapping.sql`
- `loadjava`* -> para rodar o loadjava é necessário ter o client do Database Oracle 19c instalado em sua máquina
- `package_mottu_mapping.sql`
- `test_scenarios_mottu_mapping.sql`
