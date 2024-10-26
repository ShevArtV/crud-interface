<!doctype html>
<html lang="ru" class="">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="description" content="{$_modx->resource.description}">
    <base href="{$_modx->config.site_url}">
    <title>{$_modx->resource.pagetitle}</title>

    <link rel="stylesheet" href="assets/css/vendor/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/index.css">
</head>

<body>

<div>
    <header  class="d-flex align-items-center justify-content-center py-3"></header>

    <main class="">
        {block 'content'}{/block}
    </main>

    <footer></footer>

    <div class="offcanvas offcanvas-end" data-bs-scroll="true" data-bs-backdrop="true" tabindex="-1" id="candidate_data">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title">Кандидат</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body">
            <form data-si-form data-si-preset="add_candidate">
                <input type="hidden" name="id">
                <div class="mb-3">
                    <label class="form-label">ФИО</label>
                    <input type="text" class="form-control" name="fullname">
                    <span data-si-error="fullname" class="form-text text-danger"></span>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="text" class="form-control" name="email">
                    <span data-si-error="email" class="form-text text-danger"></span>
                </div>
                <div class="mb-3">
                    <label class="form-label">Телефон</label>
                    <input type="text" class="form-control" name="phone">
                    <span data-si-error="phone" class="form-text text-danger"></span>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                    <button type="submit" class="btn btn-primary">Сохранить</button>
                    <button type="button" data-bs-toggle="offcanvas" data-bs-target="#send_invite" data-insert="" class="btn btn-success">Пригласить на тестирование</button>
                </div>
            </form>
        </div>
    </div>

    <script src="assets/js/vendor/bootstrap.bundle.min.js"></script>
    <script src="assets/js/index.js?v={''|date: 'dmYhis'}"></script>
</div>
</body>
</html>
