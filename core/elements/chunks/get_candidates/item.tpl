<li class="row align-items-center border-bottom border-1 border-secondary mx-0">
    <div class="col-4 text-center py-3 border-end border-1 border-secondary">
        <p class="mb-0">{$fullname}</p>
    </div>
    <div class="col-3 text-center py-3 border-end border-1 border-secondary">
        <p class="mb-0">{$email}</p>
    </div>
    <div class="col-3 text-center py-3 border-end border-1 border-secondary">
        <p class="mb-0">{$phone}</p>
    </div>
    <div class="col-2 text-center">
        <div class="btn-group">
            <form class="btn p-0 btn-primary" data-si-form>
                <input type="hidden" name="query" value="{$id}">
                <input type="hidden" name="popup" value="#candidate_data">
                <button type="button" class="btn btn-primary" data-si-event="click" data-si-preset="find_user" title="Изменить">
                    <i class="icon-pencil"></i>
                </button>
            </form>

            <form class="btn p-0 btn-danger" data-si-form>
                <input type="hidden" name="id" value="{$id}">
                <button type="button" class="btn btn-danger" data-si-event="click" data-si-preset="remove_user" title="Удалить">
                    <i class="icon-bin2"></i>
                </button>
            </form>
        </div>
    </div>
</li>
