<?php

namespace CustomServices;

class Users
{
    /**
     * @var \Modx
     */
    protected \ModX $modx;

    protected \pdoTools $pdoTools;

    public function __construct($modx)
    {
        $this->modx = $modx;
        $this->initialize();
    }

    protected function initialize(): void
    {
        $this->pdoTools = $this->modx->getService('pdoTools');
        $this->modx->addPackage('candidate_testing', MODX_CORE_PATH . 'components/candidate_testing/model/');
    }

    /**
     * @param \xPDOQuery $q
     * @param array $fetchType
     * @return array
     */
    protected function execute(\xPDOQuery $q, array $fetchType = [\PDO::FETCH_ASSOC]): array
    {
        $tstart = microtime(true);
        $q->prepare();
        if ($q->stmt->execute()) {
            $this->modx->queryTime += microtime(true) - $tstart;
            $this->modx->executedQueries++;
            return $q->stmt->fetchAll(implode('|', $fetchType));
        }
        return [];
    }


    public function findUser(array $data, array $properties = []): array
    {
        $query = trim($data['query']);
        if (empty($query)) {
            return ['success' => false, 'message' => 'Введите запрос.', 'data' => []];
        }

        $q = $this->modx->newQuery('modUser');
        $q->leftJoin('modUserProfile', 'Profile');
        $q->select($this->modx->getSelectColumns('modUser', 'modUser', '', ['username', 'primary_group']));
        $q->select($this->modx->getSelectColumns('modUserProfile', 'Profile'));
        $q->where(['Profile.fullname:LIKE' => "%$query%"]);
        $q->orCondition(['Profile.email' => $query]);
        $q->orCondition(['modUser.id' => $query]);

        if ($profile = $this->modx->getObject('modUser', $q)) {
            $profileData = $profile->toArray();
            $profileData['popup'] = $data['popup'];
            return ['success' => true, 'message' => 'Пользователь найден.', 'data' => $profileData];
        }
        return ['success' => false, 'message' => 'Пользователь не найден.', 'data' => []];
    }

    private function manageUser(?array $data = [], ?array $properties = []): array
    {
        $userGroup = (int)$properties['user_group'] ?: 2;

        $msg = 'Пользователь успешно обновлен';
        if ((int)$data['id']) {
            $where = ['internalKey' => $data['id']];
        } else {
            $where = ['email' => $data['email']];
        }

        if (!$profile = $this->modx->getObject('modUserProfile', $where)) {
            /** @var \modUser $user */
            $user = $this->modx->newObject('modUser');
            $user->fromArray([
                'username' => time(),
                'password' => md5(date('d.m.Y H:i:s')),
                'primary_group' => $userGroup,
                'active' => 1
            ]);
            $profile = $this->modx->newObject('modUserProfile');
            $user->addOne($profile);
            $user->save();
            $user->joinGroup($userGroup);
            $msg = 'Пользователь успешно создан';
        }

        $extended = $profile->get('extended') ?: [];
        $data['extended'] = array_merge($extended, $data['extended'] ?? []);
        $profile->fromArray($data);
        $profile->save();

        return ['success' => true, 'message' => $msg, 'data' => $profile->toArray()];
    }

    public function getListCandidates(array $data, array $properties = []): string
    {
        $properties['primaryGroup'] = 2;
        return $this->getListUsers($data, $properties);
    }

    private function getListUsers(array $data, array $properties = []): string
    {
        $output = '';
        $q = $this->modx->newQuery('modUser');
        $q->leftJoin('modUserProfile', 'Profile');
        $q->where([
            'modUser.primary_group' => $properties['primaryGroup'],
            'modUser.active' => 1,
        ]);
        if ($query = trim($data['query'])) {
            $q->where("(Profile.fullname LIKE '%$query%' OR Profile.email = '$query')");
        }
        $q->select($this->modx->getSelectColumns('modUserProfile', 'Profile'));
        $q->select($this->modx->getSelectColumns('modUser', 'modUser', '', ['username', 'primary_group']));

        $q->prepare();
        $total = $this->modx->getCount('modUser', $q);
        if ($properties['limit']) {
            $q->limit($properties['limit'], $properties['offset'] ?? 0);
        }
        $q->sortby('modUser.createdon', 'DESC');
        $items = $this->execute($q);
        foreach ($items as $item) {
            $output .= $this->pdoTools->getChunk($properties['tpl'], $item);
        }

        $this->modx->setPlaceholder($properties['totalVar'] ?? 'total', $total);
        return $output;
    }

    public function removeUser(?array $data = [], ?array $properties = []): array
    {
        if (!$user = $this->modx->getObject('modUser', (int)$data['id'])) {
            return ['success' => false, 'message' => 'Пользователь не найден', 'data' => []];
        }
        $user->remove();
        $tests = $this->modx->getIterator('AssignedTests', ['user_id' => (int)$data['id']]);
        foreach ($tests as $test) {
            $test->remove();
        }

        return ['success' => true, 'message' => 'Пользователь успешно удален', 'data' => []];
    }
}
