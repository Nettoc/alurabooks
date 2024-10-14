-- Criação do schema ncnh, caso ainda não exista
--CREATE SCHEMA IF NOT EXISTS ncnh;

-- Tabela: tb_pessoa
CREATE TABLE ncnh.tb_pessoa (
    pessoa_id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    tipo_pessoa VARCHAR(50) CHECK (tipo_pessoa IN ('lideranca', 'coletivo', 'osc')) NOT NULL,
    email VARCHAR(255) UNIQUE,
    telefone VARCHAR(20),
    endereco VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: tb_tipo_pessoa
CREATE TABLE ncnh.tb_tipo_pessoa (
    tipo_pessoa_id SERIAL PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL
);

-- Tabela: tb_pessoa_tipo_pessoa
CREATE TABLE ncnh.tb_pessoa_tipo_pessoa (
    pessoa_id INT NOT NULL,
    tipo_pessoa_id INT NOT NULL,
    PRIMARY KEY (pessoa_id, tipo_pessoa_id),
    FOREIGN KEY (pessoa_id) REFERENCES ncnh.tb_pessoa(pessoa_id),
    FOREIGN KEY (tipo_pessoa_id) REFERENCES ncnh.tb_tipo_pessoa(tipo_pessoa_id)
);

-- Tabela: tb_edital
CREATE TABLE ncnh.tb_edital (
    edital_id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('aberto', 'fechado', 'em analise', 'concluido')) DEFAULT 'aberto',
    valor_total NUMERIC(15, 2) DEFAULT 0.00,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: tb_projeto
CREATE TABLE ncnh.tb_projeto (
    projeto_id SERIAL PRIMARY KEY,
    edital_id INT NOT NULL,
    nome_projeto VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    valor_projeto NUMERIC(15, 2) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    status VARCHAR(50) CHECK (status IN ('em andamento', 'concluido', 'cancelado')) DEFAULT 'em andamento',
    pessoa_responsavel_id INT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (edital_id) REFERENCES ncnh.tb_edital(edital_id),
    FOREIGN KEY (pessoa_responsavel_id) REFERENCES ncnh.tb_pessoa(pessoa_id)
);

-- Tabela: tb_grant
CREATE TABLE ncnh.tb_grant (
    grant_id SERIAL PRIMARY KEY,
    projeto_id INT NOT NULL,
    tema VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    valor_grant NUMERIC(15, 2) NOT NULL,
    data_assinatura DATE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('em execucao', 'concluido', 'cancelado')) DEFAULT 'em execucao',
    pessoa_responsavel_id INT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (projeto_id) REFERENCES ncnh.tb_projeto(projeto_id),
    FOREIGN KEY (pessoa_responsavel_id) REFERENCES ncnh.tb_pessoa(pessoa_id)
);



-- Tabela: tb_lideranca
CREATE TABLE ncnh.tb_lideranca (
    lideranca_id SERIAL PRIMARY KEY,
    pessoa_id INT NOT NULL,
    area_atuacao VARCHAR(255),
    anos_experiencia INT,
    FOREIGN KEY (pessoa_id) REFERENCES ncnh.tb_pessoa(pessoa_id)
);

-- Tabela: tb_coletivo
CREATE TABLE ncnh.tb_coletivo (
    coletivo_id SERIAL PRIMARY KEY,
    pessoa_id INT NOT NULL,
    numero_integrantes INT,
    causa_principal VARCHAR(255),
    FOREIGN KEY (pessoa_id) REFERENCES ncnh.tb_pessoa(pessoa_id)
);

-- Tabela: tb_osc
CREATE TABLE ncnh.tb_osc (
    osc_id SERIAL PRIMARY KEY,
    pessoa_id INT NOT NULL,
    cnpj VARCHAR(18),
    ano_fundacao INT,
    FOREIGN KEY (pessoa_id) REFERENCES ncnh.tb_pessoa(pessoa_id)
);

-- Tabela: tb_area_atuacao
CREATE TABLE ncnh.tb_area_atuacao (
    area_atuacao_id SERIAL PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL
);

-- Tabela Resolvedora: tb_osc_area_atuacao
CREATE TABLE ncnh.tb_osc_area_atuacao (
    osc_id INT NOT NULL,
    area_atuacao_id INT NOT NULL,
    PRIMARY KEY (osc_id, area_atuacao_id),
    FOREIGN KEY (osc_id) REFERENCES ncnh.tb_osc(osc_id),
    FOREIGN KEY (area_atuacao_id) REFERENCES ncnh.tb_area_atuacao(area_atuacao_id)
);

-- Tabela: tb_escuta
CREATE TABLE ncnh.tb_escuta (
    escuta_id SERIAL PRIMARY KEY,
    tipo_escuta VARCHAR(50) CHECK (tipo_escuta IN ('whatsapp', 'presencial')) NOT NULL,
    descricao TEXT,
    data_escuta DATE NOT NULL,
    local_escuta VARCHAR(255),
    grupo_focal VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: tb_participante
CREATE TABLE ncnh.tb_participante (
    participante_id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    idade INT,
    data_nascimento DATE,
    genero VARCHAR(50),
    raca VARCHAR(50),
    bairro VARCHAR(255),
    tipo_participacao VARCHAR(50) CHECK (tipo_participacao IN ('whatsapp', 'presencial')) NOT NULL,
    escuta_id INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (escuta_id) REFERENCES ncnh.tb_escuta(escuta_id)
);

-- Tabela: tb_deficiencia
CREATE TABLE ncnh.tb_deficiencia (
    deficiencia_id SERIAL PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL
);

-- Tabela Resolvedora: tb_participante_deficiencia
CREATE TABLE ncnh.tb_participante_deficiencia (
    participante_id INT NOT NULL,
    deficiencia_id INT NOT NULL,
    PRIMARY KEY (participante_id, deficiencia_id),
    FOREIGN KEY (participante_id) REFERENCES ncnh.tb_participante(participante_id),
    FOREIGN KEY (deficiencia_id) REFERENCES ncnh.tb_deficiencia(deficiencia_id)
);

-- Tabela: tb_percepcao
CREATE TABLE ncnh.tb_percepcao (
    percepcao_id SERIAL PRIMARY KEY,
    participante_id INT NOT NULL,
    escuta_id INT NOT NULL,
    descricao TEXT NOT NULL,
    categoria VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (participante_id) REFERENCES ncnh.tb_participante(participante_id),
    FOREIGN KEY (escuta_id) REFERENCES ncnh.tb_escuta(escuta_id)
);

-- Tabela: tb_sugestao_reparacao
CREATE TABLE ncnh.tb_sugestao_reparacao (
    sugestao_id SERIAL PRIMARY KEY,
    participante_id INT NOT NULL,
    escuta_id INT NOT NULL,
    descricao TEXT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (participante_id) REFERENCES ncnh.tb_participante(participante_id),
    FOREIGN KEY (escuta_id) REFERENCES ncnh.tb_escuta(escuta_id)
);

-- Tabela: tb_despesas_grants
CREATE TABLE ncnh.tb_despesas_grants (
    despesa_grant_id SERIAL PRIMARY KEY,
    grant_id INT NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    valor_despesa NUMERIC(15, 2) NOT NULL,
    data_despesa DATE NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grant_id) REFERENCES ncnh.tb_grant(grant_id)
);





-- Tabela: tb_prazos_programa
CREATE TABLE ncnh.tb_prazos_programa (
    prazo_id SERIAL PRIMARY KEY,
    descricao_prazo VARCHAR(255) NOT NULL,
    data_prevista DATE NOT NULL,
    data_realizada DATE,
    status_prazo VARCHAR(50) CHECK (status_prazo IN ('pendente', 'cumprido', 'atrasado')) DEFAULT 'pendente',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: tb_produto
CREATE TABLE ncnh.tb_produto (
    produto_id SERIAL PRIMARY KEY,
    nome_produto VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    data_prevista_entrega DATE NOT NULL,
    data_entrega DATE,
    status VARCHAR(50) CHECK (status IN ('pendente', 'entregue', 'atrasado')) DEFAULT 'pendente',
    arquivo_anexo VARCHAR(255),
    data_aprovacao DATE,
    meio_aprovacao TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: tb_financas
CREATE TABLE ncnh.tb_financas (
    financa_id SERIAL PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    tipo_despesa VARCHAR(50) CHECK (tipo_despesa IN ('equipe', 'local', 'taxas internas', 'grant')) NOT NULL,
    valor NUMERIC(15, 2) NOT NULL,
    data_despesa DATE NOT NULL,
    grant_id INT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grant_id) REFERENCES ncnh.tb_grant(grant_id)
);

-- Tabela: tb_indicador
CREATE TABLE ncnh.tb_indicador (
    indicador_id SERIAL PRIMARY KEY,
    nome_indicador VARCHAR(255) NOT NULL,
    descricao TEXT,
    tipo_indicador VARCHAR(50) CHECK (tipo_indicador IN ('qualitativo', 'quantitativo')) NOT NULL,
    meta NUMERIC(15, 2),
    valor_atingido NUMERIC(15, 2),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: tb_orcamento_programa
CREATE TABLE ncnh.tb_orcamento_programa (
    orcamento_id SERIAL PRIMARY KEY,
    ano INT NOT NULL,
    orcamento_total NUMERIC(15, 2) NOT NULL DEFAULT 150000000.00,
    valor_disponivel NUMERIC(15, 2) NOT NULL,
    valor_gasto NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);