<?php
$professionals = getAllRecords($conn, 'professionals');
$services = getAllRecords($conn, 'services');
$servicesMap = [];
foreach ($services as $srv) {
    $servicesMap[$srv['id']] = $srv['name'];
}
?>
<div class="section-header">
    <h2>👔 Professionnels</h2>
    <button class="btn btn-primary" onclick="openModal('professionals', 'create')">
        ➕ Ajouter un professionnel
    </button>
</div>

<?php if (empty($professionals)): ?>
    <div class="empty-state">
        <p>Aucun professionnel trouvé.</p>
    </div>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom / Entreprise</th>
                <th>Email</th>
                <th>Téléphone</th>
                <th>Service</th>
                <th>Ville</th>
                <th>Prix</th>
                <th>Statut</th>
                <th>Disponible</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($professionals as $pro): ?>
                <tr>
                    <td><?= htmlspecialchars($pro['id'] ?? 'N/A') ?></td>
                    <td>
                        <strong><?= htmlspecialchars($pro['business_name'] ?: ($pro['first_name'] . ' ' . $pro['last_name'])) ?></strong>
                        <?php if ($pro['business_name']): ?>
                            <br><small style="color: #999;"><?= htmlspecialchars($pro['first_name'] . ' ' . $pro['last_name']) ?></small>
                        <?php endif; ?>
                    </td>
                    <td><?= htmlspecialchars($pro['email'] ?? '-') ?></td>
                    <td><?= htmlspecialchars($pro['phone'] ?? '-') ?></td>
                    <td><?= htmlspecialchars($servicesMap[$pro['service_id']] ?? '-') ?></td>
                    <td><?= htmlspecialchars($pro['city']) ?></td>
                    <td><?= htmlspecialchars($pro['base_price'] ?? '0.00') ?> MAD</td>
                    <td>
                        <?php
                        $statusBadge = [
                            'pending' => ['badge-warning', 'En attente'],
                            'verified' => ['badge-success', 'Vérifié'],
                            'rejected' => ['badge-danger', 'Rejeté'],
                            'suspended' => ['badge-danger', 'Suspendu']
                        ];
                        $status = $statusBadge[$pro['status'] ?? 'pending'] ?? ['badge-warning', $pro['status'] ?? 'pending'];
                        ?>
                        <span class="badge <?= $status[0] ?>"><?= $status[1] ?></span>
                    </td>
                    <td>
                        <span class="badge <?= ($pro['is_available'] ?? false) ? 'badge-success' : 'badge-danger' ?>">
                            <?= ($pro['is_available'] ?? false) ? 'Oui' : 'Non' ?>
                        </span>
                    </td>
                    <td>
                        <button class="btn btn-edit" onclick="openModal('professionals', 'update', '<?= $pro['id'] ?? '' ?>')">
                            ✏️ Modifier
                        </button>
                        <button class="btn btn-danger" onclick="deleteRecord('professionals', '<?= $pro['id'] ?? '' ?>')" style="padding: 6px 12px; font-size: 12px;">
                            🗑️ Supprimer
                        </button>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>
