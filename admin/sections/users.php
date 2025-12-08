<?php
$users = getAllRecords($conn, 'users');
?>
<div class="section-header">
    <h2>👥 Utilisateurs</h2>
    <button class="btn btn-primary" onclick="openModal('users', 'create')">
        ➕ Ajouter un utilisateur
    </button>
</div>

<?php if (empty($users)): ?>
    <div class="empty-state">
        <p>Aucun utilisateur trouvé.</p>
    </div>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Email</th>
                <th>Téléphone</th>
                <th>Type</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($users as $user): ?>
                <tr>
                    <td><?= htmlspecialchars($user['id']) ?></td>
                    <td><strong><?= htmlspecialchars($user['first_name'] . ' ' . $user['last_name']) ?></strong></td>
                    <td><?= htmlspecialchars($user['email']) ?></td>
                    <td><?= htmlspecialchars($user['phone'] ?? '-') ?></td>
                    <td>
                        <span class="badge <?= $user['is_guest'] ? 'badge-warning' : 'badge-success' ?>">
                            <?= $user['is_guest'] ? 'Invité' : 'Membre' ?>
                        </span>
                    </td>
                    <td>
                        <span class="badge <?= $user['is_active'] ? 'badge-success' : 'badge-danger' ?>">
                            <?= $user['is_active'] ? 'Actif' : 'Inactif' ?>
                        </span>
                    </td>
                    <td>
                        <button class="btn btn-edit" onclick="openModal('users', 'update', '<?= $user['id'] ?>')">
                            ✏️ Modifier
                        </button>
                        <button class="btn btn-danger" onclick="deleteRecord('users', '<?= $user['id'] ?>')" style="padding: 6px 12px; font-size: 12px;">
                            🗑️ Supprimer
                        </button>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>
