{extends 'file:templates/wrapper.tpl'}
{block 'content'}
    <section class="container">
        <div class="row align-items-center justify-content-between">
            <div class="col-auto">
                <h1>{$_modx->resource.pagetitle}</h1>
            </div>
            <div class="col-7">
                <form class="row" id="searchForm" data-si-form data-si-nosave data-si-preset="pagination-search">
                    <div class="col-6">
                        <input type="text" class="form-control" name="query" placeholder="ФИО/Email">
                    </div>
                    <div class="col-3">
                        <button type="submit" class="btn btn-primary w-100 d-block">Найти</button>
                    </div>
                    <div class="col-3">
                        <button type="reset" class="btn btn-outline-primary w-100 d-block" data-si-event="click">Сбросить</button>
                    </div>
                </form>
            </div>
            <div class="col-auto">
                <button type="button" data-bs-toggle="offcanvas" data-bs-target="#candidate_data" class="btn btn-outline-primary"><i class="icon-plus"></i>&nbsp;Добавить</button>
            </div>
        </div>

        <div class="row mx-0 bg-secondary text-white mt-5">
            <div class="col-4 text-center py-3 border-end border-1 border-white">ФИО</div>
            <div class="col-3 text-center py-3 border-end border-1 border-white">Email</div>
            <div class="col-3 text-center py-3 border-end border-1 border-white">Телефон</div>
            <div class="col-2 text-center py-3">Действия</div>
        </div>
        <ul class="list-unstyled border-end border-start border-1 border-secondary" data-pn-result>
            {'!Pagination' | snippet: [
            'snippet' => '!Pagination',
            'render' => '@FILE snippets/manage_users.php',
            'presetName' => 'pagination-search',
            'tpl' => '@FILE chunks/get_candidates/item.tpl',
            'tplEmpty' => '@INLINE <li class="row align-items-center border-bottom border-1 border-secondary mx-0 py-3">Кандидатов не найдено.</li>',
            'limit' => 10,
            'pagination' => 'candidates',
            'resultBlockSelector' => '[data-pn-result]',
            'resultShowMethod' => 'insert',
            'method' => 'getListCandidates',
            'hashParams' => 'query',
            ]}
        </ul>

        <!-- PAGINATION -->
        {set $totalPages = 'candidates.totalPages' | placeholder}
        {set $currentPage = 'candidates.currentPage' | placeholder}
        {set $limit = 'candidates.limit' | placeholder}

        <div data-pn-pagination="candidates" data-pn-type="" class="{$totalPages < 2 ? 'v_hidden' : ''} pagination">
            <button type="button" data-pn-first="1">&#8249;&#8249;</button>
            <button type="button" data-pn-prev="">&#8249;</button>
            <input type="number" name="candidatespage" data-pn-current data-si-preset="pagination-search" form="searchForm" min="1" max="{$totalPages}"
                   value="{$currentPage?:1}">
            <p>из
                <span data-pn-total="">{$totalPages?:1}</span>
            </p>
            <button type="button" data-pn-next="">&#8250;</button>
            <button type="button" data-pn-last="{$totalPages}">&#8250;&#8250;</button>
        </div>
    </section>
{/block}
