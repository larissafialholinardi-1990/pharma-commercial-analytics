-- ============================================================================
-- Pipeline: Carga Incremental — Histórico de Pendências e A Faturar
-- Descrição: Insere snapshot diário das tabelas operacionais no histórico,
--            garantindo idempotência via NOT EXISTS.
--
-- Padrão utilizado:
--   - INSERT ... SELECT com filtro no MAX(dh_carga) para capturar apenas
--     o snapshot mais recente da fonte (evita múltiplos snapshots intraday)
--   - NOT EXISTS correlacionado para garantir idempotência:
--     se a data já foi carregada, o INSERT não executa
--   - CURRENT_DATE - INTERVAL 1 DAY como data_carga (D-1)
--     reflete o ciclo de atualização da fonte (dados do dia anterior)
--
-- Frequência: diária (agendada via job/orquestrador)
-- Destino: tabelas Gold de histórico (Delta Lake)
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. Histórico de Pendências
-- Fonte: tabela operacional de pedidos pendentes (pipeline SAP)
-- Filtros aplicados:
--   - Snapshot mais recente do dia (MAX dh_carga)
--   - Representantes válidos (exclui códigos de sistema)
--   - Atividades comerciais ativas (lista de sg_atividade)
--   - Função de parceiro = Vendedor (cd_funcao_parceiro = 'VE')
--   - Tipo de material = FERT (mercadoria)
--   - Documentos de venda válidos (lista de sg_doc_venda)
-- ----------------------------------------------------------------------------
INSERT INTO [schema_destino].fato_historico_pendencias
SELECT
    *,
    CURRENT_DATE - INTERVAL 1 DAY AS data_carga   -- snapshot D-1

FROM [schema_fonte].fato_pendencias

WHERE
    -- Captura apenas o snapshot mais recente da fonte (evita duplicar intraday)
    dh_carga = (SELECT MAX(dh_carga) FROM [schema_fonte].fato_pendencias)

    -- Exclui representantes de sistema/placeholder
    AND cd_representante NOT IN ('[COD_SISTEMA_1]', '[COD_SISTEMA_2]')

    -- Filtra atividades comerciais relevantes
    AND sg_atividade IN (
        'AB','AC','AD','AE','AF','AG','MP',
        'AA','DI','DC','DG','FA','US','CE','DF'
    )

    -- Apenas vendedores (exclui outros papéis do parceiro)
    AND cd_funcao_parceiro = 'VE'

    -- Apenas materiais do tipo mercadoria (FERT)
    AND cd_tipo_material = 'FERT'

    -- Documentos de venda válidos (tipos SAP de pedido aberto)
    AND sg_doc_venda IN (
        'ZVPN','ZFPN','ZOPN','ZQPN','ZPPN','YVPN',
        'ZCON','ZCOV','ZVEI','ZOCV','ZQPY','ZOPY',
        'ZPPY','ZOCY'
    )

    -- Idempotência: só insere se D-1 ainda não foi carregado
    AND NOT EXISTS (
        SELECT 1
        FROM [schema_destino].fato_historico_pendencias
        WHERE data_carga = CURRENT_DATE - INTERVAL 1 DAY
    );


-- ----------------------------------------------------------------------------
-- 2. Histórico de A Faturar
-- Fonte: tabela operacional de pedidos aprovados aguardando faturamento
-- Sem filtros adicionais — toda a tabela é snapshot válido
-- Idempotência via NOT EXISTS garante que D-1 só é inserido uma vez
-- ----------------------------------------------------------------------------
INSERT INTO [schema_destino].fato_historico_a_faturar
SELECT
    *,
    CURRENT_DATE - INTERVAL 1 DAY AS data_carga   -- snapshot D-1

FROM [schema_fonte].fato_sap_ov_a_faturar

-- Idempotência: só insere se D-1 ainda não foi carregado
WHERE NOT EXISTS (
    SELECT 1
    FROM [schema_destino].fato_historico_a_faturar
    WHERE data_carga = CURRENT_DATE - INTERVAL 1 DAY
);
