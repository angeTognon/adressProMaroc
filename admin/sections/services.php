<?php
$services = getAllRecords($conn, 'services');
?>
<div class="section-header">
    <h2>🔧 Services</h2>
    <button class="btn btn-primary" onclick="openModal('services', 'create')">
        ➕ Ajouter un service
    </button>
</div>

<?php if (empty($services)): ?>
    <div class="empty-state">
        <p>Aucun service trouvé. Ajoutez-en un pour commencer.</p>
    </div>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Icône</th>
                <th>Nom</th>
                <th>Catégorie</th>
                <th>Description</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($services as $service): ?>
                <tr>
                    <td><?= htmlspecialchars($service['id'] ?? '<em style="color: #999;">Aucun ID</em>') ?></td>
                    <td style="font-size: 24px;"><?= htmlspecialchars($service['icon'] ?? '🔧') ?></td>
                    <td><strong><?= htmlspecialchars($service['name'] ?? 'Sans nom') ?></strong></td>
                    <td><?= htmlspecialchars($service['category_id'] ?? '-') ?></td>
                    <td><?= htmlspecialchars(substr($service['description'] ?? '', 0, 50)) ?>...</td>
                    <td>
                        <span class="badge <?= $service['is_active'] ? 'badge-success' : 'badge-danger' ?>">
                            <?= $service['is_active'] ? 'Actif' : 'Inactif' ?>
                        </span>
                    </td>
                    <td>
                        <button class="btn btn-edit" onclick="openModal('services', 'update', '<?= htmlspecialchars($service['id'] ?? '') ?>')">
                            ✏️ Modifier
                        </button>
                        <button class="btn btn-danger" onclick="deleteServiceRecord('<?= htmlspecialchars($service['id'] ?? '') ?>', '<?= htmlspecialchars(addslashes($service['name_fr'] ?? $service['name'] ?? '')) ?>')" style="padding: 6px 12px; font-size: 12px;">
                            🗑️ Supprimer
                        </button>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>

