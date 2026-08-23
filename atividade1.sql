--Tabela de Categorias (Sem FK):
CREATE TABLE TB_CATEGORIA (
    id_categoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(50) NOT NULL
);

-- Tabela de Clientes
CREATE TABLE TB_CLIENTE (
    id_cliente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(150) NOT NULL,
    email VARCHAR2(120) NOT NULL UNIQUE,
    cpf VARCHAR2(11) UNIQUE,
    ativo CHAR(1) DEFAULT 'S' CHECK (ativo IN ('S', 'N'))
);

-- Tabela de Vendedores 
CREATE TABLE TB_VENDEDOR (
    id_vendedor NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(120) NOT NULL,
    email VARCHAR2(120) NOT NULL UNIQUE,
    ativo CHAR(1) DEFAULT 'S' CHECK (ativo IN ('S', 'N'))
);

-- Tabela de Produtos (Depende de TB_CATEGORIA)
CREATE TABLE TB_PRODUTO (
    id_produto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_categoria NUMBER,
    sku VARCHAR2(30) NOT NULL UNIQUE,
    nome VARCHAR2(120) NOT NULL,
    preco_unit NUMBER(12,2) CHECK (preco_unit > 0),
    CONSTRAINT fk_tb_produto_categoria FOREIGN KEY (id_categoria) REFERENCES TB_CATEGORIA(id_categoria)
);

-- Tabela de Vendas (Depende de TB_CLIENTE e TB_VENDEDOR)
CREATE TABLE TB_VENDA (
    id_venda NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente NUMBER,
    id_vendedor NUMBER,
    dt_venda DATE DEFAULT SYSDATE,
    valor_liquido NUMBER(14,2),
    canal VARCHAR2(20) CHECK (canal IN ('APP', 'SITE', 'LOJA', 'TELEFONE')),
    status VARCHAR2(20) CHECK (status IN ('ABERTA', 'FECHADA', 'CANCELADA')),
    CONSTRAINT fk_tb_venda_cliente FOREIGN KEY (id_cliente) REFERENCES TB_CLIENTE(id_cliente),
    CONSTRAINT fk_tb_venda_vendedor FOREIGN KEY (id_vendedor) REFERENCES TB_VENDEDOR(id_vendedor)
);

-- Tabela de Itens da Venda (Depende de TB_VENDA e TB_PRODUTO)
CREATE TABLE TB_VENDA_ITEM (
    id_venda_item NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_venda NUMBER,
    id_produto NUMBER,
    quantidade NUMBER(10) NOT NULL CHECK (quantidade > 0),
    valor_unit NUMBER(12,2) NOT NULL,
    percentual_desconto NUMBER(5,2) DEFAULT 0 CHECK (percentual_desconto <= 50),
    valor_total NUMBER(14,2),
    CONSTRAINT fk_tb_item_venda FOREIGN KEY (id_venda) REFERENCES TB_VENDA(id_venda) ON DELETE CASCADE,
    CONSTRAINT fk_tb_item_produto FOREIGN KEY (id_produto) REFERENCES TB_PRODUTO(id_produto)
);