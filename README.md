# rF2 MAS Builder Script

## PT (english below)

Script PowerShell para criar arquivos `.mas` em lote para o rFactor 2 usando o ModMgr.exe.

### Requisitos

- Windows
- rFactor 2 instalado (ModMgr.exe)

### Estrutura de pastas

Coloque o script e o `.bat` na mesma pasta que as subpastas com os arquivos:

```
sua-pasta/
├── mas_builder.bat
├── mas_v3.ps1
├── _OutputMAS/          ← criada automaticamente
├── Veiculo01/
│   ├── arquivos...
└── Veiculo02/
│   ├── arquivos...
└── Pista01/
│   ├── arquivos...
```

### Configurações

Abra o `mas_v3.ps1` e edite a seção no topo:

```powershell
$modMgrPath  = "C:\Program Files (x86)\Steam\steamapps\common\rFactor 2\Bin64\ModMgr.exe"
$pastaOutput = "" # Deixe vazio para usar "_OutputMAS" na pasta do script
```

Ajuste o `$modMgrPath` se o seu rFactor 2 estiver instalado em outro local.

### Como usar

1. Coloque suas subpastas com os arquivos ao lado do script;
2. Dê dois cliques em `mas_builder.bat`;
3. Selecione quais subpastas empacotar (números individuais ou `0` para todas);
4. Escolha se quer usar o nome da pasta como nome do `.mas` ou digitar um personalizado;
5. Os arquivos `.mas` gerados serão salvos em `_OutputMAS`.

### Tipos de arquivo suportados

Qualquer tipo de arquivo é aceito. Os mais comuns no rFactor 2 incluem:
`.dds`, `.png`, `.veh`, `.ini`, `.json`, `.sfx`, entre outros.

### Observações

- A pasta `_OutputMAS` é excluída da lista de subpastas;
- Se já existir um `.mas` com o mesmo nome na pasta de saída, ele será substituído;
- O nível de compressão usado é o máximo suportado pelo ModMgr (`-z9`).

## EN

A PowerShell script to batch create `.mas` files for rFactor 2 using ModMgr.exe.

### Requirements

- Windows
- rFactor 2 installed (ModMgr.exe)

### Folder structure

Place the script and the `.bat` file in the same folder as your asset subfolders:
```
foler/
├── mas_builder.bat\n
├── mas_v3.ps1
├── _OutputMAS/          ← created automatically
├── Car01/
│   ├── files...
└── Car02/
│   ├── files..
└── Track01/
│   ├── files...
```
### Settings

Open `mas_v3.ps1` and edit the top section:

```powershell
$modMgrPath  = "C:\Program Files (x86)\Steam\steamapps\common\rFactor 2\Bin64\ModMgr.exe"
$pastaOutput = "" # Leave empty to use "_OutputMAS" in the script's folder
```

Adjust `$modMgrPath` if your rFactor 2 is installed in a different location.

### How to use

1. Place your asset subfolders alongside the script;
2. Double-click `mas_builder.bat`;
3. Select which subfolders to pack (individual numbers or `0` for all);
4. Choose whether to use the folder name as the `.mas` filename or type a custom one;
5. The generated `.mas` files will be saved in `_OutputMAS`.

### Supported file types

Any file type is accepted. Common rFactor 2 assets include:
`.dds`, `.png`, `.veh`, `.ini`, `.json`, `.sfx`, among others.

### Notes

- The `_OutputMAS` folder is excluded from the subfolder list;
- If a `.mas` with the same name already exists in the output folder, it will be overwritten;
- The compression level used is the maximum supported by ModMgr (`-z9`).
